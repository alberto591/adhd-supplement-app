# 0051. AI-Powered Intelligence Architecture

Date: 2026-01-30

## Status

Accepted

## Context

The user requires highly personalized, scientifically grounded supplement recommendations that go beyond simple static lists. We need a system that can analyze user goals and current stacks while providing deep technical reasoning.

## Decision

We will implement a dual-layer intelligence system for supplement recommendations.

### Layer 1: Instant Smart Matching (Local)
- **Mechanism**: Pre-computed keyword mapping between user goals (e.g., "Deep Sleep") and supplement benefits (e.g., "GABA support").
- **Latency**: O(N) local filtering, zero latency.
- **Role**: Provides immediate UI feedback and populates the "For You" list instantly upon selection change.

### Layer 2: Deep Intelligence Analysis (AI)
- **Engine**: Perplexity API using `sonar-reasoning-pro` model.
- **Mechanism**: On-demand reasoning analysis that takes the user's specific goals and current stack as context.
- **Output**: Returns a JSON-structured list of Top 3 recommendations with specific "Chemist Notes."
- **Cleanup**: Custom logic in `PerplexityService` handles AI "patter" and markdown extraction to ensure parseable JSON.

### Security & Safety:
- The AI is instructed via `chemistSystemPrompt` to act as a senior neuro-chemist and prioritize safety and synergy.
- All dynamic recommendations include disclaimers and should be cross-referenced with the app's internal safety records.

## Consequences

**Positive:**
- Combines the speed of local logic with the reasoning depth of modern LLMs.
- Personalized "Chemist" persona adds premium value and trust.
- Structured JSON output allows for a native UI experience rather than a "chatbot" feel.

**Negative:**
- Dependency on external API availability and costs.
- Latency (3-7s) for the Deep Analysis phase (mitigated by loading states and local fallback).
