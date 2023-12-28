from dataclasses import dataclass


@dataclass
class CreateQrRequest:
    giphy_id: str
    text: str
    transparency: int
    version: int
