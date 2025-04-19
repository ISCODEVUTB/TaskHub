from abc import ABC, abstractmethod
from typing import Any


class ExternalTool(ABC):
    @abstractmethod
    def execute(self, data: Any) -> dict:
        pass


class ExternalToolManager:
    def use_tool(self, tool: ExternalTool, data: Any) -> dict:
        return tool.execute(data)
