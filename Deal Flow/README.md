# Deal Flow — Pitch Evaluation & Prioritization

This folder holds incoming pitch documents for evaluation. Each pitch gets a subfolder following the same naming convention as portfolio companies.

## How to Add a Pitch

1. **Create a folder:** `{Sector} - {Company Name}/`
   ```
   mkdir "Fintech - NovaPay"
   mkdir "Climate - GreenGrid"
   ```

2. **Drop pitch documents into the folder:**
   - Pitch decks (PDF/PPT)
   - One-pagers
   - Financial models (Excel)

3. **Run Claude** and say: *"Evaluate the new pitches"*

4. **Check the output:** `Claude Summary/Deal Flow.html` — ranked prioritization dashboard

## What Happens

Claude scores each pitch on a **100-point rubric** across 6 dimensions:

| Dimension | Points | What It Assesses |
|-----------|--------|-----------------|
| Team | 25 | Founder-market fit, domain expertise, completeness |
| Market | 20 | TAM/SAM, growth rate, timing, regulation |
| Traction | 20 | Revenue, users, retention, PMF signals |
| Product / Differentiation | 15 | Moat, defensibility, switching costs |
| Business Model | 10 | Unit economics, margins, scalability |
| Deal Terms | 10 | Valuation, round size, use of proceeds |

**Priority tiers based on score:**
- **75-100 — High Priority:** Take a meeting
- **55-74 — Needs Research:** Promising but incomplete
- **35-54 — Low Priority:** Not compelling right now
- **0-34 — Pass:** Clear misfit

## Important

- **This is initial evaluation, not deep diligence.** Pitches get a quick structured assessment — not the deep financial analysis that portfolio companies receive.
- **Missing information pulls scores down.** A pitch that omits unit economics or retention data cannot score well in those dimensions.
- **One pitch at a time.** Claude evaluates one pitch per cycle, then asks which to evaluate next.
- **Graduation:** When a pitch leads to an investment, the company "graduates" to a portfolio company folder for full tracking.
