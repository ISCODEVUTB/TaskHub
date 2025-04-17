from abc import ABC, abstractmethod
from typing import Any

class ExternalTool(ABC):
    @abstractmethod
    def execute(self, data: Any) -> Any:
        pass


class ExternalToolManager:
    def use_tool(self, tool: ExternalTool, data: Any) -> Any:
        return tool.execute(data)
