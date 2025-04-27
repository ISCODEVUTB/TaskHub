from utils.jwt_manager import create_token, verify_token


def test_create_and_verify_token():
    data = {"sub": "testuser"}
    token = create_token(data)
    payload = verify_token(token)

    assert payload["sub"] == "testuser"
