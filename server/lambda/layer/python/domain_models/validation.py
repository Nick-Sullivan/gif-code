from dataclasses import Field, fields
from enum import Enum
from typing import Dict, List, Set, Tuple


def validate_request(request_body: Dict, request_type) -> List[str]:
    error_msgs = []
    dataclass_fields = fields(request_type)
    
    required_field_names = {f.name for f in dataclass_fields}
    provided_field_names = set(request_body)

    error_msgs = (
        _validate_missing_fields(required_field_names, provided_field_names)
        + _validate_unrecognised_fields(required_field_names, provided_field_names)
        + _validated_enum_values(dataclass_fields, request_body)
        + _validate_field_types(dataclass_fields, request_body))

    return error_msgs


def _validate_missing_fields(required: Set[str], provided: Set[str]) -> List[str]:
    missing_fields = required - provided
    if missing_fields:
        return [f'Missing fields: {sorted(missing_fields)}']
    return []


def _validate_unrecognised_fields(required: Set[str], provided: Set[str]) -> List[str]:
    extra_fields = provided - required
    if extra_fields:
        return [f'Unrecognised fields: {sorted(extra_fields)}']
    return []


def _validated_enum_values(required: Tuple[Field], provided: Dict) -> List[str]:
    wrong_values = {}
    for field in required:
        if field.name not in provided:
            continue

        if not issubclass(field.type, Enum):
            continue

        allowed_values = [e.value for e in field.type]
        if provided[field.name] not in allowed_values:
            wrong_values[field.name] = allowed_values

    if wrong_values:
        entries = []
        for key, allowed_values in wrong_values.items():
            entries.append("{'" + key + "': [" + ','.join(allowed_values) + "]" + "}")
        expected_str = ','.join(entries)
        return [f'Expected values: [{expected_str}]']
    return []


def _validate_field_types(required: Tuple[Field], provided: Dict) -> List[str]:
    wrong_types = {}
    for field in required:
        if field.name not in provided:
            continue

        if issubclass(field.type, Enum):
            continue

        if not isinstance(provided[field.name], field.type):
            wrong_types[field.name] = field.type.__name__

    if wrong_types:
        expected_types = ','.join(
            "{'" + key + "': " + value + '}'
            for key, value in wrong_types.items())

        return [f'Expected types: [{expected_types}]']
    return []