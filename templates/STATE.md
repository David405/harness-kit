# LOOP STATE — <PROJECT>

> Working memory for an automated/triage loop. Distinct from FEATURES.json (feature status)
> and from ephemeral review packets. The agent forgets between runs; this file does not.

## Last run

- <timestamp> — <what the run did / cadence>

## Triaged findings

| id | finding | source (CI/issue/commit) | disposition |
|----|---------|--------------------------|-------------|
| <id> | <what was found> | <where> | <queued / sprint / inbox / dropped> |

## Tried and failed (do not re-attempt without new info)

| what was attempted | why it failed | date |
|--------------------|---------------|------|
| <attempt> | <reason> | <date> |

## Human-attention inbox

- <items the loop could not handle and escalated to a person>
