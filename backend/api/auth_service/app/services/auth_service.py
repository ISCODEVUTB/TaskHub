import os
from datetime import datetime, timezone # Removed timedelta
from typing import Any, Dict

from api.auth_service.app.schemas.user import TokenDTO, UserProfileDTO, UserRegisterDTO
from api.shared.exceptions.auth_exceptions import (
    EmailAlreadyExistsException,
    InvalidCredentialsException,
    InvalidTokenException,
    # TokenExpiredException, # No longer raised directly by methods in this class
)
# Imports from api.shared.utils.jwt are no longer needed here
from api.shared.utils.supabase import SupabaseManager
from fastapi import HTTPException # For raising 500 error for unexpected issues


class AuthService:
    """Service for authentication operations"""

    def __init__(self):
        """Initialize AuthService with SupabaseManager"""
        self.supabase_manager = SupabaseManager()
        self.token_expire_minutes = int(os.getenv("ACCESS_TOKEN_EXPIRE_MINUTES", "30"))

    def register(self, user_data: UserRegisterDTO) -> TokenDTO:
        """
        Register a new user.

        Args:
            user_data (UserRegisterDTO): User registration data

        Returns:
            TokenDTO: Authentication tokens

        Raises:
            EmailAlreadyExistsException: If email already exists
        """
        try:
            # Create user meta_data
            user_meta_data = {
                "full_name": user_data.full_name,
                "company_name": user_data.company_name,
            }

            # Sign up user in Supabase
            response = self.supabase_manager.sign_up(
                user_data.email, user_data.password, user_meta_data
            )

            if not response.session:
                # This case might happen if email confirmation is pending
                # Depending on desired UX, could raise an error or return a specific DTO
                raise InvalidCredentialsException("User registration succeeded, but session not available. Please confirm your email.")

            # Get session data
            session = response.session

            # Extract token details from Supabase session
            access_token = session.access_token
            refresh_token = session.refresh_token
            expires_at_timestamp = session.expires_at
            expires_at_dt = datetime.fromtimestamp(expires_at_timestamp, tz=timezone.utc)
            token_type = session.token_type

            # Return tokens
            return TokenDTO(
                access_token=access_token,
                refresh_token=refresh_token,
                expires_at=expires_at_dt,
                token_type=token_type,
            )
        except Exception as _e:
            # Check if email already exists
            if "already exists" in str(_e):
                raise EmailAlreadyExistsException()
            raise _e

    def login(self, email: str, password: str) -> TokenDTO:
        """
        Login a user.

        Args:
            email (str): User email
            password (str): User password

        Returns:
            TokenDTO: Authentication tokens

        Raises:
            InvalidCredentialsException: If credentials are invalid
        """
        try:
            # Sign in user in Supabase
            response = self.supabase_manager.sign_in(email, password)

            if not response.session:
                 raise InvalidCredentialsException("Login failed, session not available.")

            # Get session data
            session = response.session

            # Extract token details from Supabase session
            access_token = session.access_token
            refresh_token = session.refresh_token
            expires_at_timestamp = session.expires_at
            expires_at_dt = datetime.fromtimestamp(expires_at_timestamp, tz=timezone.utc)
            token_type = session.token_type
            
            # Return tokens
            return TokenDTO(
                access_token=access_token,
                refresh_token=refresh_token,
                expires_at=expires_at_dt,
                token_type=token_type,
            )
        except Exception as _e:
            # Invalid credentials
            raise InvalidCredentialsException()

    def logout(self, token: str) -> Dict[str, Any]:
        """
        Logout a user.

        Args:
            token (str): JWT token

        Returns:
            Dict[str, Any]: Logout response

        Raises:
            InvalidTokenException: If token is invalid
        """
        try:
            # Sign out user in Supabase
            self.supabase_manager.sign_out(token)

            # Return success response
            return {"message": "Logged out successfully"}
        except Exception as _e:
            # Invalid token
            raise InvalidTokenException()

    def get_user_profile(self, token: str) -> UserProfileDTO:
        """
        Get user profile.

        Args:
            token (str): JWT token

        Returns:
            UserProfileDTO: User profile

        Raises:
            InvalidTokenException: If token is invalid
            HTTPException: If there is an unexpected error processing the profile
        """
        try:
            # print(f"[DEBUG AuthService.get_user_profile] Attempting to get user from Supabase with token: {token[:20]}...") # Optional debug line
            response = self.supabase_manager.get_user(token)
            user = response.user # This is a User object from supabase-py

            user_meta_data = getattr(user, "user_meta_data", {}) or {}
            if not isinstance(user_meta_data, dict):
                user_meta_data = {}

            # Helper to handle datetime conversion robustly
            def _to_datetime(timestamp_val):
                if timestamp_val is None:
                    return None
                if isinstance(timestamp_val, datetime):
                    return timestamp_val # Already a datetime object
                if isinstance(timestamp_val, str):
                    # Handle 'Z' for UTC if present, common in ISO strings
                    # Also handle potential existing timezone info from fromisoformat compat
                    try:
                        if timestamp_val.endswith('Z'):
                            # Replace Z with +00:00 for full ISO compatibility across Python versions
                            return datetime.fromisoformat(timestamp_val[:-1] + '+00:00')
                        dt_obj = datetime.fromisoformat(timestamp_val)
                        # If it's naive, assume UTC, as Supabase timestamps are UTC
                        if dt_obj.tzinfo is None:
                            return dt_obj.replace(tzinfo=timezone.utc)
                        return dt_obj
                    except ValueError as ve:
                        print(f"[WARN AuthService.get_user_profile] Could not parse timestamp string '{timestamp_val}': {ve}")
                        return None # Or raise a specific error / handle as appropriate
                if isinstance(timestamp_val, (int, float)): # Supabase might return epoch timestamp
                    try:
                        return datetime.fromtimestamp(timestamp_val, tz=timezone.utc)
                    except ValueError as ve:
                        print(f"[WARN AuthService.get_user_profile] Could not parse numeric timestamp '{timestamp_val}': {ve}")
                        return None
                
                print(f"[WARN AuthService.get_user_profile] Unexpected type for timestamp '{timestamp_val}': {type(timestamp_val)}")
                return None # Or raise error

            created_at_dt = _to_datetime(user.created_at)
            updated_at_dt = _to_datetime(user.updated_at) if user.updated_at else None
            
            if not isinstance(created_at_dt, datetime) and user.created_at is not None:
                 # This implies parsing failed for a non-None original value or type was unexpected
                 print(f"[ERROR AuthService.get_user_profile] Failed to convert user.created_at (value: {user.created_at}, type: {type(user.created_at)}) to datetime.")
                 raise HTTPException(status_code=500, detail="Error processing user profile data (created_at).")

            return UserProfileDTO(
                id=user.id,
                email=user.email,
                full_name=user_meta_data.get("full_name", ""),
                company_name=user_meta_data.get("company_name", ""),
                role="user", # Default role
                created_at=created_at_dt,
                updated_at=updated_at_dt,
            )
        except InvalidTokenException as e: # Re-raise specific known auth exceptions
            # This might be raised by supabase_manager.get_user() if token is truly invalid by Supabase
            raise e 
        except HTTPException as e: # If we raised one above
            raise e
        except Exception as e:
            # Log the original error for server-side debugging
            print(f"[ERROR AuthService.get_user_profile] Unexpected exception processing user profile: {type(e).__name__} - {str(e)}")
            import traceback
            print(traceback.format_exc())
            # Raise a generic server error to the client
            raise HTTPException(status_code=500, detail="An internal error occurred while processing the user profile.")
