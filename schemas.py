"""Structured output schemas for Gemini Oracle responses."""

from typing import List, Optional
from pydantic import BaseModel, Field


class Step(BaseModel):
    """A single step in the execution plan."""
    order: int = Field(description="Step number")
    action: str = Field(description="What to do")
    details: str = Field(description="How to do it")
    validation: str = Field(description="How to verify this step succeeded")


class Risk(BaseModel):
    """A potential risk or consideration."""
    risk: str = Field(description="What could go wrong")
    mitigation: str = Field(description="How to prevent or handle it")
    severity: str = Field(description="low, medium, or high")


class OracleResponse(BaseModel):
    """Structured response from the Gemini Oracle."""
    decision: str = Field(description="The key decision or recommendation")
    reasoning: str = Field(description="Why this is the right approach")
    steps: List[Step] = Field(description="Ordered steps to execute")
    risks: List[Risk] = Field(description="Potential risks and mitigations")
    success_criteria: List[str] = Field(description="How to know when done")
    clarifying_questions: Optional[List[str]] = Field(
        default=None,
        description="Questions to ask if more info needed"
    )


class ArchitectureDecision(BaseModel):
    """For architecture/design decisions."""
    chosen_approach: str
    alternatives_considered: List[str]
    tradeoffs: str
    implementation_notes: str


class ValidationResponse(BaseModel):
    """For validating Claude's work against the plan."""
    is_on_track: bool
    progress_percentage: int
    completed_steps: List[int]
    current_issues: List[str]
    recommended_adjustments: List[str]
    should_continue: bool


# JSON schemas for Gemini structured output
ORACLE_RESPONSE_SCHEMA = {
    "type": "object",
    "properties": {
        "decision": {"type": "string"},
        "reasoning": {"type": "string"},
        "steps": {
            "type": "array",
            "items": {
                "type": "object",
                "properties": {
                    "order": {"type": "integer"},
                    "action": {"type": "string"},
                    "details": {"type": "string"},
                    "validation": {"type": "string"}
                },
                "required": ["order", "action", "details", "validation"]
            }
        },
        "risks": {
            "type": "array",
            "items": {
                "type": "object",
                "properties": {
                    "risk": {"type": "string"},
                    "mitigation": {"type": "string"},
                    "severity": {"type": "string"}
                },
                "required": ["risk", "mitigation", "severity"]
            }
        },
        "success_criteria": {
            "type": "array",
            "items": {"type": "string"}
        },
        "clarifying_questions": {
            "type": "array",
            "items": {"type": "string"}
        }
    },
    "required": ["decision", "reasoning", "steps", "risks", "success_criteria"]
}

VALIDATION_RESPONSE_SCHEMA = {
    "type": "object",
    "properties": {
        "is_on_track": {"type": "boolean"},
        "progress_percentage": {"type": "integer"},
        "completed_steps": {
            "type": "array",
            "items": {"type": "integer"}
        },
        "current_issues": {
            "type": "array",
            "items": {"type": "string"}
        },
        "recommended_adjustments": {
            "type": "array",
            "items": {"type": "string"}
        },
        "should_continue": {"type": "boolean"}
    },
    "required": ["is_on_track", "progress_percentage", "completed_steps", "current_issues", "recommended_adjustments", "should_continue"]
}
