# Crisis Communication Protocol: VoidAI

## When to Activate

Activate this protocol immediately if ANY of the following occur:
- Bridge exploit, vulnerability disclosure, or smart contract incident
- Lending platform exploit, liquidation cascade, or smart contract vulnerability
- Service disruption affecting user funds or bridge/lending operations
- Lending platform delay beyond communicated timeline (company-defining crisis)
- Subnet 106 deregistration or emissions disruption
- Community backlash, astroturfing accusations, or coordinated attack
- Regulatory action or legal threat
- Competitor attack or disinformation campaign targeting VoidAI
- Leaked internal documents or architecture details
- Lending metrics trigger: TVL drops >30% in 24h, borrow utilization exceeds 95%, mass liquidation event (>10% of total collateral liquidated)

## Proactive Communication Triggers (Don't Wait for the Danger Zone)

These are NOT crises but early warning signs that require increased communication before they become crises. The goal: never let the narrative get away from VoidAI.

### SN106 Mindshare or Ranking Drop

**Trigger**: SN106 drops 2+ positions in mindshare ranking on taostats.io, OR mindshare percentage drops below 1.5% (currently 2.01%).

**Response (within 24 hours of detection):**
1. Increase @v0idai posting to 2-3 posts/day for the next 7 days (up from 1-2)
2. Prioritize builder-credibility content: what has shipped recently, what is in active development
3. Post at least 1 thread per week showing technical progress or data insights
4. Increase reply engagement: 15-20 quality replies/day on Bittensor ecosystem posts
5. Activate satellite accounts to post ecosystem analysis positioning SN106 among peers

**Content themes during ranking recovery:**
- Bridge volume updates with specific numbers
- Technical deep-dives on architecture decisions (Chainlink CCIP, concentrated liquidity)
- Roadmap updates (lending platform progress)
- Community engagement posts (AMAs, polls, question threads)

**What NOT to do:**
- Don't mention the ranking drop explicitly ("we dropped in mindshare"). It amplifies the negative
- Don't panic-post low-quality content to increase volume
- Don't attack competitors who moved above SN106

### Emissions Drop or Subnet Performance Decline

**Trigger**: SN106 daily emissions drop >20% week-over-week, OR validator/miner count drops significantly.

**Response (within 48 hours):**
1. Post a transparent builder update: "Here's what's happening with SN106 and what we're doing about it"
2. Frame with context: is this a network-wide trend or SN106-specific?
3. If SN106-specific, share the technical response plan
4. Increase community engagement in Discord/Telegram to address questions directly

### Extended Quiet Period

**Trigger**: No original post from @v0idai for 48+ hours (excluding planned breaks announced in advance).

**Response (immediate):**
1. Post a builder update or ecosystem observation to break the silence
2. Review and replenish the content queue to prevent recurrence
3. Log the gap in `brand/voice-learnings.md`

---

## Immediate Response (First 30 Minutes)

1. **ACTIVATE THE KILL SWITCH** (see Technical Kill Switch below). Target: under 60 seconds.
2. **Do NOT delete or edit** any prior posts about security, safety, or performance
3. **Do NOT engage** with speculation, FUD, or trolls
4. **Assess scope**: What happened? What is affected? What do we know vs. don't know?
5. **Draft factual acknowledgment** (human-approved ONLY, Vew must approve before posting)

---

## Technical Kill Switch: EMERGENCY_STOP

This is the automated mechanism to halt ALL publishing within seconds. Every n8n workflow checks the `EMERGENCY_STOP` environment variable before making any external API call. When set to `true`, workflows log a halt message to Discord and exit without posting.

### Activation Procedure (Target: Under 60 Seconds)

**Step 1.** Log into n8n at `https://vew.app.n8n.cloud` (bookmark this URL).

**Step 2.** Navigate to Settings > Variables. Set `EMERGENCY_STOP` to `true`. Save.

**Step 3.** Navigate to the Workflows list. Deactivate all 5 active workflows:
  - WF1: Daily Metrics Post
  - WF2: Bridge Transaction Alerts
  - WF3: Weekly Recap Thread
  - WF4: Ecosystem News Monitor
  - WF5: Content Calendar Scheduler

**Step 4.** Post a manual hold message to Discord (via the webhook or directly in the channel):

> **ALL PUBLISHING HALTED.** EMERGENCY_STOP activated at [time UTC]. All 5 workflows deactivated. Reason: [brief description]. Updates to follow.

**Why both the variable AND deactivation?** The variable stops any workflow that is mid-execution from completing its publish step. Deactivating workflows prevents new executions from starting. Together, they provide a complete halt with no race conditions.

### What EMERGENCY_STOP Does Per Workflow

| Workflow | Effect |
|----------|--------|
| WF1: Daily Metrics | Halts before posting the daily metrics tweet. Data fetch may still complete (read-only, no side effects). |
| WF2: Bridge Alerts | Halts before posting bridge transaction alerts. Webhook/cron still fires but exits at the check node. |
| WF3: Weekly Recap | Halts before writing drafts to the queue and sending Discord notifications. |
| WF4: News Monitor | Halts before writing news drafts and sending Discord notifications. |
| WF5: Content Scheduler | Halts before scheduling or posting any approved content. |

### JavaScript Code Node: Emergency Stop Check

Add this as the **first Code node** in every workflow, immediately after the trigger node. Name the node `Emergency Stop Check`.

```javascript
// EMERGENCY STOP CHECK
// Must be the first code node in every workflow, right after the trigger.
// Checks the EMERGENCY_STOP environment variable. If true, sends a
// notification to Discord and halts the workflow (returns empty array).
//
// Referenced in: crisis.md, n8n-workflow-specs.md
// Variable: EMERGENCY_STOP (Settings > Variables)

const emergencyStop = $env.EMERGENCY_STOP;

if (emergencyStop === 'true' || emergencyStop === true) {
  // Identify which workflow triggered this check
  const workflowName = $workflow.name || 'Unknown Workflow';
  const timestamp = new Date().toISOString();

  // Send halt notification to Discord
  const discordUrl = $env.DISCORD_WEBHOOK_URL;
  if (discordUrl) {
    try {
      await fetch(discordUrl, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({
          content: `**EMERGENCY STOP ACTIVE** | Workflow "${workflowName}" halted at ${timestamp}. No content was published. Set EMERGENCY_STOP=false in n8n variables to resume.`
        })
      });
    } catch (e) {
      // Discord notification failed, but we still halt.
      // The workflow execution log in n8n will show this ran.
    }
  }

  // Return empty array to stop the workflow from proceeding
  return [];
}

// EMERGENCY_STOP is not active. Pass through all input items unchanged.
return $input.all();
```

**Node configuration:**
- **Type:** Code (JavaScript)
- **Mode:** Run Once for All Items
- **Position:** Immediately after the trigger node (Cron or Webhook)
- **On Error:** Stop Workflow
- **Output:** If emergency stop is active, returns `[]` (empty), which terminates the workflow. If not active, passes all input items through to the next node.

### n8n Workflow Node Insertion Points

| Workflow | Insert After | Connect To |
|----------|-------------|------------|
| WF1: Daily Metrics | Node 1 (Cron Trigger) | Node 2 (Taostats API) |
| WF2: Bridge Alerts | Node 1a/1b (Webhook or Cron Trigger) | Node 2 (Fetch Recent Txs) or Node 4 (Filter Threshold) |
| WF3: Weekly Recap | Node 1 (Cron Trigger) | Node 2a/2b/2c/2d/2e (parallel data fetch) |
| WF4: News Monitor | Node 1 (Cron Trigger) | Node 2a/2b/2c/2d (RSS feeds) |
| WF5: Content Scheduler | Node 1 (Cron Trigger) | Node 2 (Read Approved Queue) |

---

## Recovery Procedure: Resuming After an Incident

Follow these steps in order. Do not skip steps. Do not rush.

**Step 1. Verify the incident is resolved.** Confirm with the team (or independently verify) that the root cause is addressed, funds are safe, and no ongoing exploit or vulnerability is active.

**Step 2. Audit the content queue.** Review every item in `queue/approved/` and `queue/scheduled/`. Purge or move to `queue/rejected/` any content that:
  - References the incident in a way that is now outdated or misleading
  - Contains metrics or data from during the incident that may be inaccurate
  - Was auto-generated by a workflow during the incident window
  - Could be misread as tone-deaf given what just happened

**Step 3. Set `EMERGENCY_STOP=false`.** In n8n Settings > Variables, change `EMERGENCY_STOP` from `true` to `false`. Save.

**Step 4. Reactivate workflows one at a time with `DRY_RUN=true`.** Set `DRY_RUN=true` in n8n variables, then reactivate workflows in this order (wait for each to complete one execution before activating the next):
  1. WF1: Daily Metrics Post (lowest risk, read-only data)
  2. WF2: Bridge Transaction Alerts (verify bridge data is accurate post-incident)
  3. WF3: Weekly Recap Thread (outputs to drafts only, human review required)
  4. WF4: Ecosystem News Monitor (outputs to drafts only)
  5. WF5: Content Calendar Scheduler (controls actual publishing, activate last)

**Step 5. Test each workflow.** For each reactivated workflow:
  - Execute it manually in the n8n editor
  - Inspect every node's output for correctness
  - Check log files in `LOG_FILE_PATH` to verify dry-run output looks accurate
  - Confirm Discord notifications are received

**Step 6. Set `DRY_RUN=false`.** Once all 5 workflows have been tested successfully in dry-run mode, set `DRY_RUN=false` in n8n variables. This resumes live publishing.

**Step 7. Post recovery confirmation to Discord:**

> **PUBLISHING RESUMED.** All 5 workflows reactivated and tested at [time UTC]. EMERGENCY_STOP=false, DRY_RUN=false. Normal operations restored.

**Step 8. Resume satellite accounts per the schedule below** (see Per-Account Crisis Behavior above):
  1. Daily/Informational (first, factual updates)
  2. Bittensor Ecosystem
  3. DeFi / Cross-Chain (last)

---

## Response Templates

### For Bridge / Technical Incidents

> We are aware of [specific issue]. [X funds are affected / No funds are affected]. The bridge is [paused/operational]. Our team is [specific action being taken]. We will update every [timeframe]. Thread below with details.

### For Community / Reputational Incidents

> We've seen the discussion about [topic]. Here's the context: [factual explanation]. We take this seriously and [specific action]. Happy to answer questions directly.

### For Regulatory / Legal

> We are aware of [development]. We are reviewing with counsel and will share updates as appropriate. VoidAI remains committed to [compliance/transparency/user protection].

## Per-Account Crisis Behavior

| Account | During Crisis |
|---------|--------------|
| Main @v0idai | ONLY account that posts official updates. Factual, transparent, no spin. |
| Daily/Informational | May share ONLY official @v0idai updates via quote-tweet. No independent posts. |
| Bittensor Ecosystem | May share ONLY official @v0idai updates via quote-tweet. No independent commentary. |
| DeFi / Cross-Chain | May share ONLY official @v0idai updates via quote-tweet. No independent commentary. |

## What NEVER To Do During a Crisis

- Continue posting memes, promotional content, or engagement bait
- Delete or edit prior posts about security, safety, or performance
- Make unverified claims about fund safety
- Promise compensation before assessment is complete
- Go silent for more than 4 hours during an active incident
- Blame users or external parties without verified evidence
- Minimize the situation ("this is nothing," "FUD")
- Let any satellite account freelance. All messaging comes from main account only

## Post-Crisis

- Follow the **Recovery Procedure** above to safely resume publishing
- Publish a post-mortem within 72 hours (factual, technical, transparent)
- Update `brand/voice-learnings.md` with crisis communication lessons
- Resume satellite account activity gradually per the Recovery Procedure Step 8
- Review and update this protocol based on what worked and what did not
- Log the incident in the Changelog below with timestamps for: EMERGENCY_STOP activated, workflows deactivated, EMERGENCY_STOP cleared, workflows reactivated

---

## Changelog

| Date | Change | Approved by |
|------|--------|-------------|
| 2026-03-15 | Added Technical Kill Switch (EMERGENCY_STOP), activation procedure, recovery procedure, JS code node spec | Vew |
| 2026-03-13 | Initial crisis protocol extracted from CLAUDE.md (config audit remediation) | Vew |
| 2026-03-22 | Added Proactive Communication Triggers: SN106 ranking drop, emissions decline, extended quiet period per X Playbook tip 5 | Vew |
| 2026-03-25 | Lending pivot: added lending crisis triggers (exploit, delay, TVL drop, utilization spike, liquidation cascade), updated per-account behavior for 4 accounts, updated recovery resume order. | Vew |
