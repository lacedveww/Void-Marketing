# VoidAI Phase 1a: System Testing & Validation Plan

**Document Owner:** Vew (Marketing Lead)
**Created:** 2026-03-13
**Status:** DRAFT -- awaiting approval before test execution
**Dependencies:** CLAUDE.md (compliance rules), queue-manager/SKILL.md (queue spec), content-review-rules.md (review tiers), AUDIT-challenger-verdict.md (8 fixes applied, SHOULD FIX 9-17 pending)
**Scope:** Full system validation of the content queue pipeline, compliance checks, templates, cadence rules, and end-to-end lifecycle before any content goes public.

---

## How To Use This Plan

Each test case uses the format:

- **ID**: Category prefix + sequential number (e.g., QS-01 = Queue System test 01)
- **Description**: What is being tested
- **Preconditions**: State the system must be in before the test
- **Steps**: Exact actions to take
- **Expected Result**: What success looks like
- **Priority**: P0 (blocks launch), P1 (must fix before soft launch), P2 (fix before Phase 4)

Priority definitions:
- **P0**: If this test fails, Phase 1a cannot proceed. Content could be published with compliance violations, data could be lost, or core functionality is broken.
- **P1**: Functional gap that creates risk during soft launch but can be worked around manually. Fix before going live with DRY_RUN=false.
- **P2**: Edge case, cosmetic, or optimization issue. Track for later.

Test execution: Run all P0 tests first. If any P0 test fails, stop and fix before continuing. P1 tests can be run in parallel. P2 tests are informational.

---

## 1. Queue System Command Tests

### `/queue add`

**QS-01: Basic content creation with explicit parameters**
- Priority: P0
- Description: `/queue add` creates a new item in `drafts/`, auto-runs compliance, auto-advances to `review/`, and presents a review card.
- Preconditions: Queue directories exist. `manifest.json` is valid. CLAUDE.md, voice-learnings.md, and content-review-rules.md are readable.
- Steps:
  1. Run `/queue add --platform x --account v0idai --pillar bridge-build --type single --source manual --priority 3`
  2. Provide content body when prompted: "VoidAI bridge processed $2.4M in cross-chain volume this week. SN106 mindshare: 2.01% (#5). 99.8% uptime across Bittensor, Solana, and Ethereum. Not financial advice. Digital assets are volatile and carry risk of loss. DYOR."
- Expected Result:
  - File created with filename pattern `{YYYYMMDD}-{HHMMSS}-x-v0idai-{slug}.md`
  - Frontmatter populated: `status: "review"`, `platform: "x"`, `account: "v0idai"`, `pillar: "bridge-build"`, `content_type: "single"`, `priority: 3`, `source_workflow: "manual"`, `generated_by: "claude"`
  - Compliance fields populated (all 6 steps run)
  - File physically located in `queue/review/` (not `drafts/`)
  - `manifest.json` regenerated with the new item
  - In-chat review card displayed with all fields from the review card format spec

**QS-02: Template selection by platform and type**
- Priority: P0
- Description: Verify that `/queue add` selects the correct template based on `--platform` and `--type` combinations.
- Preconditions: All 13 templates present in `queue/templates/`.
- Steps:
  1. Test each combination and verify the correct template is loaded:
     - `--platform x --type single` -> `x-single.md`
     - `--platform x --type thread` -> `x-thread.md`
     - `--platform linkedin` -> `linkedin-post.md`
     - `--platform discord` -> `discord-announcement.md`
     - `--platform blog` -> `blog-post.md`
     - `--platform podcast` -> `podcast-notebooklm.md`
     - `--platform x --type video` -> `video-script.md` (not video-google-veo.md, since video-script is the default recorded video template)
     - `--type infographic` -> `infographic.md`
     - `--type data-card` -> `data-card.md`
     - `--type image --platform x` -> `image-social-graphic.md`
     - `--type image --platform blog` -> `image-content-hero.md`
     - `--type slide-deck` -> `slide-deck.md`
- Expected Result: Each combination loads the correct template. Content type-specific frontmatter fields (e.g., `video_duration`, `seo_title`, `slide_count`) are present in the generated file.

**QS-03: Missing platform/template fallback behavior**
- Priority: P0
- Description: Test what happens when `/queue add` is called with a platform or type that has no template.
- Preconditions: No `telegram.md` or `youtube.md` template exists.
- Steps:
  1. Run `/queue add --platform telegram --account v0idai --pillar bridge-build`
  2. Run `/queue add --platform youtube --account v0idai --pillar bridge-build`
  3. Run `/queue add --platform x --account v0idai --type reply --pillar bridge-build`
  4. Run `/queue add --platform x --account v0idai --type quote_tweet --pillar bridge-build`
  5. Run `/queue add --platform x --account v0idai --type meme --pillar community-culture`
- Expected Result: System should either (a) gracefully fall back to a generic template, (b) use the closest match (e.g., x-single for reply/quote_tweet), or (c) display a clear error message indicating the template does not exist. The system must NOT crash, produce a corrupt file, or silently continue without a template. Document whichever behavior occurs -- this informs whether missing templates need to be created before soft launch.

**QS-04: Auto-review card presentation (critical behavioral test)**
- Priority: P0
- Description: Verify the auto-review rule: every `/queue add` immediately presents a review card for approval. Content must NEVER be silently saved to drafts without presentation.
- Preconditions: None.
- Steps:
  1. Run `/queue add --platform x --account v0idai --pillar ecosystem-intelligence`
  2. Observe whether a review card is displayed
  3. Verify the card format matches the spec in SKILL.md lines 117-134
  4. Verify the card includes: Platform, Account, Pillar, Chars/Limit, Compliance summary, Review Tier, Red Flags, Dry Run flag, and full content body
- Expected Result: Review card is displayed inline immediately after content generation. User is prompted to approve or reject. No content sits silently in `drafts/`.

**QS-05: Required parameter validation**
- Priority: P1
- Description: Test that `/queue add` rejects calls with missing required parameters.
- Preconditions: None.
- Steps:
  1. Run `/queue add` with no parameters
  2. Run `/queue add --platform x` (missing --account and --pillar)
  3. Run `/queue add --platform x --account v0idai` (missing --pillar)
  4. Run `/queue add --platform x --account invalid_account --pillar bridge-build` (invalid account name)
  5. Run `/queue add --platform x --account v0idai --pillar invalid-pillar` (invalid pillar)
- Expected Result: Each missing/invalid parameter produces a clear error message identifying which parameter is missing or invalid. No file is created. No manifest update occurs.

**QS-06: Satellite account content creation**
- Priority: P0
- Description: Test creating content for each satellite account and verifying persona-appropriate defaults.
- Preconditions: None.
- Steps:
  1. Run `/queue add --platform x --account voidai_memes --pillar community-culture --type single`
  2. Run `/queue add --platform x --account voidai_tao --pillar ecosystem-intelligence --type single`
  3. Run `/queue add --platform x --account voidai_defi --pillar alpha-education --type single`
- Expected Result: Each item is created with the correct account. Content generated matches the satellite persona voice rules from CLAUDE.md. Disclaimer format is appropriate for the account (e.g., "nfa // dyor" for voidai_memes, not the full formal disclaimer). Compliance check Step 4 accepts the account-specific disclaimer variant.

---

### `/queue list`

**QS-07: List with no filters**
- Priority: P1
- Description: `/queue list` displays all items from manifest.json.
- Preconditions: At least 3 items in different statuses exist.
- Steps:
  1. Run `/queue list`
- Expected Result: Table displayed with columns: ID | Status | Platform | Account | Pillar | Priority | Compliance | Created. All items from manifest.json are shown.

**QS-08: List with filters**
- Priority: P1
- Description: Filters reduce the displayed items correctly.
- Preconditions: Items exist across multiple statuses, accounts, platforms, and pillars.
- Steps:
  1. Run `/queue list --status review`
  2. Run `/queue list --account voidai_memes`
  3. Run `/queue list --platform x`
  4. Run `/queue list --pillar bridge-build`
  5. Run `/queue list --priority 3` (should show items with priority <= 3)
  6. Run `/queue list --status review --account v0idai` (combined filters)
- Expected Result: Each filter correctly narrows results. Combined filters apply AND logic. Empty results show a clear "no items match" message rather than an empty table.

**QS-09: List from empty queue**
- Priority: P2
- Description: `/queue list` on an empty queue does not error.
- Preconditions: All queue directories are empty (no .md files). Manifest has zero items.
- Steps:
  1. Run `/queue list`
- Expected Result: Displays a message like "No items in queue" or an empty table. Does not error.

---

### `/queue review`

**QS-10: Single item review**
- Priority: P0
- Description: `/queue review` presents items in `review/` as rich in-chat cards.
- Preconditions: At least 1 item in `queue/review/`.
- Steps:
  1. Run `/queue review`
  2. Observe the review card format
  3. Respond with "approve"
- Expected Result: Review card matches the spec format. After "approve", the item moves to `queue/approved/` with `reviewed_by: "vew"`, `reviewed_at` set, and status updated.

**QS-11: Multiple item sequential review**
- Priority: P1
- Description: With multiple items in review, cards are shown one at a time.
- Preconditions: 3+ items in `queue/review/`.
- Steps:
  1. Run `/queue review`
  2. Approve first item
  3. Verify second item is shown
  4. Reject second item with reason
  5. Skip third item
- Expected Result: Items shown sequentially. After all items, summary displayed: "1 approved, 1 rejected, 1 skipped". Approved item in `approved/`, rejected item in `rejected/` with reason, skipped item still in `review/`.

**QS-12: Review with account filter**
- Priority: P2
- Description: `/queue review --account voidai_memes` only shows items for that account.
- Preconditions: Items from multiple accounts in `queue/review/`.
- Steps:
  1. Run `/queue review --account voidai_memes`
- Expected Result: Only voidai_memes items are shown. Items from other accounts remain untouched.

**QS-13: Review response variations**
- Priority: P1
- Description: All documented approval/rejection phrases work.
- Preconditions: Items in `queue/review/`.
- Steps:
  1. Respond to review cards with each of: "approve", "approved", "yes", "lgtm", "ship it"
  2. Respond with: "reject" + reason, "no" + reason, "nah" + reason
  3. Respond with: "skip", "next"
  4. Respond with: "edit: make the hook more specific with a data point"
- Expected Result: Each phrase triggers the correct action. "edit:" sends the item back to drafts with the feedback attached.

---

### `/queue approve`

**QS-14: Standard approval flow**
- Priority: P0
- Description: Approving an item in review moves it to approved with proper metadata.
- Preconditions: Item exists in `queue/review/`.
- Steps:
  1. Run `/queue approve <id> --notes "Good content, approved for scheduling"`
- Expected Result: File moved to `queue/approved/`. Frontmatter updated: `status: "approved"`, `previous_status: "review"`, `reviewed_by: "vew"`, `reviewed_at` set to current time, `review_notes` contains the notes. `manifest.json` regenerated.

**QS-15: Approve item not in review**
- Priority: P1
- Description: Cannot approve an item that is not in review status.
- Preconditions: Item exists in `queue/drafts/` (not yet moved to review).
- Steps:
  1. Run `/queue approve <id>` where the item is in drafts
- Expected Result: Error message: item is not in review status. No file movement occurs.

---

### `/queue reject`

**QS-16: Standard rejection flow**
- Priority: P0
- Description: Rejecting an item moves it to rejected with reason.
- Preconditions: Item in `queue/review/`.
- Steps:
  1. Run `/queue reject <id> --reason "Too generic, needs specific bridge volume data"`
- Expected Result: File moved to `queue/rejected/`. Frontmatter: `status: "rejected"`, `previous_status: "review"`, `rejection_reason` populated, `reviewed_by: "vew"`, `reviewed_at` set. User sees message about using `/queue move <id> drafts` to rework. Manifest regenerated.

**QS-17: Reject without reason**
- Priority: P2
- Description: Rejecting without `--reason` either errors or prompts for a reason.
- Preconditions: Item in `queue/review/`.
- Steps:
  1. Run `/queue reject <id>` (no --reason)
- Expected Result: Either (a) prompts user for a reason, or (b) rejects with a note that no reason was provided. Document behavior.

---

### `/queue schedule`

**QS-18: Schedule an approved item**
- Priority: P0
- Description: Scheduling moves item from approved to scheduled with cadence validation.
- Preconditions: Item in `queue/approved/`. No conflicting items already scheduled.
- Steps:
  1. Run `/queue schedule <id> --at "2026-03-17T14:30:00Z"`
- Expected Result: File moved to `queue/scheduled/`. Frontmatter: `status: "scheduled"`, `previous_status: "approved"`, `scheduled_post_at: "2026-03-17T14:30:00Z"`. Manifest regenerated.

**QS-19: Schedule with cadence conflict**
- Priority: P0
- Description: Scheduling detects and reports cadence violations.
- Preconditions: One v0idai item already scheduled at 2026-03-17T14:30:00Z.
- Steps:
  1. Run `/queue schedule <id2> --at "2026-03-17T15:00:00Z"` (only 30 min gap, v0idai requires 3 hour minimum)
- Expected Result: Cadence violation reported: "Minimum 3 hour gap required for v0idai. Nearest post at 14:30. Suggested: 17:30 or later." User asked to confirm override or pick different time.

**QS-20: Schedule on weekend**
- Priority: P1
- Description: Weekend scheduling enforces max 1 post/day per account.
- Preconditions: One v0idai item already scheduled for Saturday 2026-03-21.
- Steps:
  1. Run `/queue schedule <id> --at "2026-03-21T20:00:00Z"` (Saturday, already has 1 post)
- Expected Result: Warning: "Weekend limit: max 1 post/day per account on weekends. v0idai already has 1 post on 2026-03-21." Ask user to confirm or reschedule to a weekday.

**QS-21: Schedule unapproved item**
- Priority: P1
- Description: Cannot schedule an item that is not in approved status.
- Preconditions: Item in `queue/review/` or `queue/drafts/`.
- Steps:
  1. Run `/queue schedule <id> --at "2026-03-17T14:30:00Z"` on a non-approved item
- Expected Result: Error: "Item must be in approved status to schedule."

---

### `/queue schedule-day`

**QS-22: Auto-schedule approved items for a day**
- Priority: P1
- Description: Schedules all approved items into available slots respecting cadence.
- Preconditions: 3 approved items for v0idai. No existing scheduled items.
- Steps:
  1. Run `/queue schedule-day 2026-03-17 --account v0idai`
- Expected Result: System proposes schedule placing items into peak windows (14:00-16:00, 20:00-22:00 UTC) with 3+ hour gaps. Max 2 items placed (v0idai max 2/day). Third item flagged as "exceeds daily limit, deferred." Proposed schedule shown for confirmation.

**QS-23: Auto-schedule on weekend**
- Priority: P1
- Description: Weekend auto-scheduling places max 1 post per account.
- Preconditions: 3 approved items for v0idai.
- Steps:
  1. Run `/queue schedule-day 2026-03-22 --account v0idai` (Sunday)
- Expected Result: Only 1 item scheduled. Remaining 2 deferred. Warning about weekend limits.

---

### `/queue calendar`

**QS-24: Calendar display**
- Priority: P1
- Description: Calendar shows day-by-day, hour-by-hour grid of scheduled items.
- Preconditions: Items scheduled across multiple days and accounts.
- Steps:
  1. Run `/queue calendar --days 7`
- Expected Result: Grid shows: items per account per day, gap analysis (flags spacing violations), daily post counts, pillar distribution for period, empty slots highlighted.

**QS-25: Calendar with no scheduled items**
- Priority: P2
- Description: Calendar on empty schedule does not error.
- Preconditions: No items in `queue/scheduled/`.
- Steps:
  1. Run `/queue calendar`
- Expected Result: Empty calendar displayed or "No items scheduled" message.

---

### `/queue check`

**QS-26: Run compliance check on existing item**
- Priority: P0
- Description: `/queue check` runs all 6 compliance steps and updates frontmatter.
- Preconditions: Item exists in any status.
- Steps:
  1. Run `/queue check <id>`
- Expected Result: All 6 compliance steps run (Category A, B, C, disclaimer, Howey, tier assignment). Frontmatter compliance fields updated. Detailed results table displayed showing each step and its pass/fail status.

**QS-26b: Verify `/queue check` persists frontmatter to disk**
- Priority: P0
- Description: After `/queue check` runs, verify that compliance fields are actually written to the file on disk, not just displayed in the chat output.
- Preconditions: Item exists with `compliance_passed` not yet set (or set to a known value).
- Steps:
  1. Run `/queue check <id>`
  2. Read the file directly from disk (not from chat output)
  3. Verify that `compliance_passed`, `prohibited_language`, `disclaimer_included`, `howey_risk`, `review_tier`, `red_flags_found`, and `compliance_checked_at` fields are present and populated in the file's YAML frontmatter
- Expected Result: All compliance fields are persisted to the physical file. The frontmatter on disk matches what was displayed in the check results. This ensures `/queue check` is not display-only.

**QS-26c: `/queue check` on item with stale compliance after content edit**
- Priority: P1
- Description: After content is modified (e.g., moved back to drafts and edited), `/queue check` re-runs and produces fresh results reflecting the new content.
- Preconditions: Item exists with `compliance_passed: true` from a previous check. Content has been manually edited to include a prohibited term.
- Steps:
  1. Take an item that previously passed compliance
  2. Manually edit the content body to include "guaranteed returns"
  3. Run `/queue check <id>`
- Expected Result: `compliance_passed` flips from `true` to `false`. `prohibited_language` flips from `"pass"` to `"fail"`. `compliance_checked_at` is updated to the current time. The check reflects the current content, not cached results.

---

### `/queue batch-approve`

**QS-27: Batch approve from workflow source**
- Priority: P1
- Description: Batch-approve approves all items from a specific workflow that pass compliance.
- Preconditions: 3 items in `queue/review/` with `source_workflow: "daily-metrics"` and `compliance_passed: true`. 1 item with `compliance_passed: false`.
- Steps:
  1. Run `/queue batch-approve --workflow daily-metrics`
- Expected Result: 3 passing items listed for confirmation. After confirm, all 3 moved to `approved/`. The failing item is skipped with a warning. Manifest regenerated.

**QS-28: Batch approve with max limit**
- Priority: P2
- Description: `--max` parameter limits the number of approvals.
- Preconditions: 5 eligible items.
- Steps:
  1. Run `/queue batch-approve --workflow daily-metrics --max 2`
- Expected Result: Only 2 items approved (sorted by priority). Remaining 3 left in review.

---

### `/queue move`

**QS-29: Valid state transitions**
- Priority: P0
- Description: Test all valid transitions from the transition table.
- Preconditions: Items exist in various statuses.
- Steps: Test each transition:
  1. `drafts -> review`
  2. `review -> approved`
  3. `review -> rejected`
  4. `review -> drafts`
  5. `approved -> scheduled` (with schedule time)
  6. `approved -> drafts`
  7. `scheduled -> approved`
  8. `scheduled -> cancelled`
  9. `rejected -> drafts`
  10. `failed -> drafts`
  11. `failed -> scheduled`
  12. Any status -> `cancelled`
- Expected Result: Each transition moves the file to the correct directory, updates `status`, `previous_status`, and `updated_at` in frontmatter. Manifest regenerated after each.

**QS-30: Invalid state transitions**
- Priority: P1
- Description: Invalid transitions are blocked.
- Preconditions: Items in various statuses.
- Steps: Test invalid transitions:
  1. `drafts -> approved` (skips review)
  2. `drafts -> scheduled` (skips review and approval)
  3. `approved -> rejected` (not in the valid table)
  4. `posted -> drafts` (posted is final)
  5. `cancelled -> review` (cancelled is final except for drafts rework)
- Expected Result: Each invalid transition produces a clear error message listing valid transitions for the item's current status. No file movement.

**QS-31: Move with review->approved bypass concern (SHOULD FIX item 13 from audit)**
- Priority: P1
- Description: `/queue move <id> approved` from review bypasses the `/queue approve` flow, skipping `reviewed_by`, `reviewed_at`, and `review_notes` fields.
- Preconditions: Item in `queue/review/`.
- Steps:
  1. Run `/queue move <id> approved`
  2. Check the resulting frontmatter for `reviewed_by`, `reviewed_at`, `review_notes`
- Expected Result: Document the current behavior. If the move proceeds without setting reviewer fields, log as a confirmed gap that needs fixing per audit M3 recommendation.

---

### `/queue stats`

**QS-32: Queue statistics display**
- Priority: P1
- Description: Stats shows counts, distribution, and metrics.
- Preconditions: Items in various statuses and pillars.
- Steps:
  1. Run `/queue stats`
  2. Run `/queue stats --account v0idai`
- Expected Result: Displays: counts by status, pillar distribution vs. targets (with drift warnings if >5%), posts per account (today/week/all-time), average time in each status, compliance pass/fail rates, items by source workflow. Account filter narrows to that account only.

---

### `/queue rebuild`

**QS-33: Rebuild from files**
- Priority: P0
- Description: Manifest is regenerated correctly from files on disk.
- Preconditions: Multiple items exist across directories. Current manifest.json may be stale.
- Steps:
  1. Run `/queue rebuild`
- Expected Result: Manifest regenerated. All `.md` files (excluding `.gitkeep`) are parsed. Counts match actual directory contents. Pillar distribution recalculated. Any inconsistencies reported (file in wrong directory vs. status field).

**QS-34: Rebuild with non-content files in queue directories (regression for UG1 fix)**
- Priority: P0
- Description: Rebuild does not crash on non-content markdown files that lack proper YAML frontmatter.
- Preconditions: A markdown file without YAML frontmatter exists in a queue subdirectory (simulates audit report scenario that was fixed by moving reports to `reviews/`).
- Steps:
  1. Create a file `queue/drafts/test-no-frontmatter.md` with just "# This is not a content item"
  2. Run `/queue rebuild`
  3. Remove the test file afterward
- Expected Result: Rebuild either (a) skips the file and logs a warning, or (b) errors and reports the specific file that failed parsing. Must NOT silently create a broken manifest entry. Per SKILL.md error handling: "If a compliance check fails to parse content, set all compliance fields to their most restrictive values and flag for manual review."

**QS-35: Rebuild with missing manifest**
- Priority: P1
- Description: Any queue command auto-triggers rebuild when manifest is missing.
- Preconditions: Delete or rename `manifest.json`.
- Steps:
  1. Rename `manifest.json` to `manifest.json.bak`
  2. Run `/queue list`
- Expected Result: System auto-detects missing manifest, triggers rebuild, then executes the list command. Restore backup afterward.

**QS-36: Rebuild with status/directory mismatch**
- Priority: P1
- Description: A file with `status: "approved"` sitting in `queue/review/` is corrected.
- Preconditions: Manually place a file with `status: "approved"` in `queue/review/`.
- Steps:
  1. Run `/queue rebuild`
- Expected Result: Rebuild detects the inconsistency. File is moved to the correct directory (`queue/approved/`). The correction is logged.

---

### `/queue stagger`

**QS-37: Create stagger group**
- Priority: P1
- Description: Stagger group assigns correct order and timing to multi-account items.
- Preconditions: 4 items exist, one per account (v0idai, voidai_memes, voidai_tao, voidai_defi).
- Steps:
  1. Run `/queue stagger bridge-launch-v1 --items <id1>,<id2>,<id3>,<id4>`
- Expected Result: Each item gets `stagger_group: "bridge-launch-v1"`. Orders assigned: v0idai=1, voidai_memes=2, voidai_tao=3, voidai_defi=4. If any items are already scheduled, timing validation checks: fanpage 2+ hours after main, bittensor 3+ hours, defi 4+ hours.

**QS-38: Stagger with same-account items**
- Priority: P2
- Description: Stagger group should verify items cover different accounts.
- Preconditions: 2 items both from v0idai.
- Steps:
  1. Run `/queue stagger test-group --items <id1>,<id2>` (both v0idai)
- Expected Result: Warning or error: "Stagger groups should cover different accounts."

---

### `/queue cleanup`

**QS-39: Cleanup dry run**
- Priority: P1
- Description: Cleanup with `--dry-run` lists items but does not delete.
- Preconditions: Items in `queue/posted/` with `posted_at` more than 30 days ago.
- Steps:
  1. Run `/queue cleanup --dry-run`
- Expected Result: List of items that would be removed is displayed. No files deleted. No manifest change.

**QS-40: Cleanup execution**
- Priority: P2
- Description: Cleanup deletes old posted items.
- Preconditions: Items in `queue/posted/` older than 30 days.
- Steps:
  1. Run `/queue cleanup`
  2. Confirm deletion
- Expected Result: Old items deleted. Manifest regenerated. Confirmation message with count of removed items.

**QS-41: Cleanup with no old items**
- Priority: P2
- Description: Cleanup when nothing is old enough to remove.
- Preconditions: All posted items are less than 30 days old.
- Steps:
  1. Run `/queue cleanup`
- Expected Result: "No items older than 30 days found." No action taken.

---

### `/queue export-batch`

**QS-42: Export items as JSON**
- Priority: P2
- Description: Export converts YAML frontmatter to flat JSON for Notion import.
- Preconditions: Items in `queue/approved/` status.
- Steps:
  1. Run `/queue export-batch --status approved`
- Expected Result: JSON file created at `queue/export-approved-{timestamp}.json`. Each item's frontmatter is a flat JSON object. Content body maps to `content` field. Count and path displayed.

---

## 2. Compliance Check Validation

### Step 1: Category A Word Scan

**CC-01: Clean content passes Category A**
- Priority: P0
- Description: Content with no prohibited terms passes the scan.
- Preconditions: None.
- Steps:
  1. Create content: "VoidAI bridge processed $2.4M in cross-chain volume this week. SN106 mindshare: 2.01%. Not financial advice. Digital assets are volatile and carry risk of loss. DYOR."
  2. Run `/queue check` on this item
- Expected Result: `prohibited_language: "pass"`, `compliance_passed: true` (assuming no other checks fail).

**CC-02: Prohibited terms trigger failure**
- Priority: P0
- Description: Each Category A term must be detected and cause failure.
- Preconditions: None.
- Steps: Test content containing each prohibited term individually:
  1. "VoidAI offers guaranteed returns on staking"
  2. "This is a risk-free bridge"
  3. "No risk when using VoidAI bridge"
  4. "VoidAI is a safe investment"
  5. "Get rich with VoidAI staking"
  6. "Achieve financial freedom with SN106"
  7. "Earn passive income by staking TAO"
  8. "VOID token to the moon"
  9. "Potential 100x on VOID token"
  10. "VoidAI is SEC-approved"
  11. "FDIC-insured deposits via VoidAI"
  12. "Invest in VoidAI bridge" (investment language for token purchase)
  13. "Earn rewards by staking" (earn for staking)
  14. "High yield on SN106" (yield without variable qualifier)
  15. "Profit from VoidAI protocol participation"
  16. "High APY available on VoidAI" (high APY without specific rate/disclaimer)
  17. "Receive your token allocation from VoidAI" (allocation in rewards context)
  18. "Complete tasks to receive the VoidAI airdrop" (airdrop as incentive)
- Expected Result: Every single test content triggers `prohibited_language: "fail"`, `compliance_passed: false`. Content is blocked and flagged for rewrite.

**CC-03: Case-insensitive detection**
- Priority: P0
- Description: Category A scan works case-insensitively.
- Preconditions: None.
- Steps:
  1. Test "GUARANTEED RETURNS on staking"
  2. Test "Passive Income from VoidAI"
  3. Test "To The Moon"
- Expected Result: All detected regardless of case.

**CC-04: L33tspeak and misspelling detection**
- Priority: P1
- Description: Common evasion attempts are caught.
- Preconditions: None.
- Steps:
  1. Test "gu4r4nteed returns"
  2. Test "r1sk-free bridge"
  3. Test "passiv income"
  4. Test "to da moon"
  5. Test "f1nancial fr33dom"
- Expected Result: Document which variants are caught and which are not. Flag any missed variants as gaps to add to the scanner rules.

**CC-05: Compliant substitutions pass**
- Priority: P0
- Description: The approved language substitutions from CLAUDE.md pass without flags.
- Preconditions: None.
- Steps:
  1. Test "Participate in SN106 network validation and receive variable rate rewards"
  2. Test "Network-generated rewards are variable and subject to change"
  3. Test "Current estimated rate of 12%, subject to change"
  4. Test "VoidAI bridge is audited and open-source"
- Expected Result: `prohibited_language: "pass"`. None of these trigger Category A violations.

**CC-06: Context-dependent language (VoidAI vs. ecosystem)**
- Priority: P1
- Description: Prohibited terms used in ecosystem/educational context vs. VoidAI promotional context.
- Preconditions: None.
- Steps:
  1. Test (educational, should be flagged for review but not auto-fail): "Yield farming strategies across Ethereum DeFi have shifted toward concentrated liquidity positions."
  2. Test (promotional, should fail): "Bridge your TAO to earn yield on Ethereum via VoidAI."
- Expected Result: Both test cases will trigger Category B flagging ("yield farming"). Test case 1 (educational) will trigger Category B for "yield farming" but the Category A scan cannot distinguish educational from promotional context -- "yield" without "variable" qualifier triggers Category A failure regardless of context. Test case 2 (promotional) will ALSO trigger Category A failure ("earn" applied to VoidAI + "yield" without "variable" qualifier). **The compliance system cannot distinguish context automatically -- this is by design.** Category A is a text-matching scan, not semantic analysis. Human review at Tier 1 is the mechanism for context judgment. If this test shows the system correctly flags both for human review, the compliance design is working as intended. Document the exact behavior: if the system auto-passes educational content or auto-fails educational content, record which, as this determines whether educational DeFi content needs to avoid "yield" entirely or can rely on Tier 1 review to override.

---

### Step 2: Category B Word Scan

**CC-07: Category B terms flagged for review**
- Priority: P0
- Description: Context-dependent terms are recorded in red_flags_found with surrounding context.
- Preconditions: None.
- Steps: Test content containing:
  1. "Current estimated APY: 12%, subject to change" (OK usage of APY)
  2. "VoidAI Lending TVL: $1.2M" (factual TVL)
  3. "Alpha on cross-chain liquidity trends" (OK alpha usage)
  4. "Bittensor ecosystem activity looks bullish" (commentary)
  5. "Don't sleep on $VOID -- this is a hidden gem" (NEVER OK for VOID token)
- Expected Result: Each Category B term recorded in `red_flags_found[]` with the matched term and surrounding context. Item 5 should get special treatment: "undervalued", "gem", "hidden gem" are NEVER acceptable for VOID token and should force Tier 1. All items correctly escalate to human review for context judgment.

**CC-08: Category B terms combined with Category A**
- Priority: P1
- Description: An item with both Category A and B violations correctly reports both.
- Preconditions: None.
- Steps:
  1. Test: "Guaranteed high APY on VoidAI staking. TVL growing fast. VOID is undervalued."
- Expected Result: Category A fail ("guaranteed", "high APY" without rate, "undervalued" for VOID). Category B flags on "APY", "TVL", "undervalued". `compliance_passed: false`, `prohibited_language: "fail"`, `red_flags_found` contains all flagged terms.

---

### Step 3: Category C Competitor Scan

**CC-09: Competitor name detection**
- Priority: P0
- Description: Any competitor name triggers auto Tier 1 assignment.
- Preconditions: None.
- Steps: Test content mentioning:
  1. "Project Rubicon"
  2. "Wormhole bridge"
  3. "LayerZero"
  4. "Axelar"
  5. "Aave lending"
  6. "Compound protocol"
  7. "SN75" (another subnet compared to SN106)
- Expected Result: Each triggers `review_tier: 1`. Competitor name recorded in `red_flags_found`. Content is not auto-failed (competitor mentions are OK if factual) but requires human review.

**CC-10: Competitor in educational context**
- Priority: P1
- Description: Educational content mentioning competitors gets Tier 1 but is not rejected.
- Preconditions: None.
- Steps:
  1. Test: "Cross-chain bridges like Wormhole, LayerZero, and VoidAI each take different approaches to message verification."
- Expected Result: `review_tier: 1` due to competitor names. `compliance_passed: true` (no Category A violations). Red flags list all competitor names found. Content is held for human review, not auto-rejected.

---

### Step 4: Disclaimer Verification

**CC-11: Standard disclaimer detection per platform and account**
- Priority: P0
- Description: Each platform/account combination accepts the correct disclaimer variants.
- Preconditions: None.
- Steps: Test disclaimer detection for each combination:
  1. X single + v0idai: "Not financial advice. Digital assets are volatile and carry risk of loss. DYOR." -> should pass
  2. X single + voidai_memes: "nfa // dyor" -> should pass
  3. X single + voidai_memes: "not financial advice obv" -> should pass
  4. X single + voidai_memes: "nfa obv" -> should pass
  5. X single + voidai_tao: "NFA. DYOR." -> should pass
  6. X single + voidai_tao: full standard disclaimer -> should also pass (satellites accept both short and standard)
  7. X single + voidai_defi: "Informational only -- not financial advice. DYOR." -> should pass
  8. X single + voidai_defi: "Not financial advice. DYOR." -> should pass
  9. LinkedIn + any: full long-form disclaimer at bottom -> should pass
  10. Blog + any: full long-form disclaimer + risk disclosures -> should pass
  11. Discord + any: standard short disclaimer -> should pass
  12. Video + any: spoken disclaimer in script body + description field -> should pass
  13. Podcast + any: spoken disclaimer in intro/outro + show notes -> should pass
- Expected Result: `disclaimer_included: true` for each. Matching is case-insensitive and substring-based (not exact match).

**CC-12: Missing disclaimer detection**
- Priority: P0
- Description: Content without any disclaimer is flagged.
- Preconditions: None.
- Steps:
  1. Test X single post with v0idai account and no disclaimer text anywhere in content
- Expected Result: `disclaimer_included: false`. Content can still pass compliance overall (missing disclaimer does not auto-fail per current spec) but the flag alerts the human reviewer.

**CC-13: Satellite disclaimer variant acceptance (regression test for audit fix #4)**
- Priority: P0
- Description: After the fix for UG2 (Step 4 accepting account-specific disclaimer variants), verify satellites are no longer falsely flagged.
- Preconditions: The disclaimer check lookup table has been updated per audit fix.
- Steps:
  1. Create content for voidai_memes with "nfa // dyor" as disclaimer
  2. Run `/queue check`
  3. Verify `disclaimer_included: true`
  4. Repeat for voidai_tao with "NFA. DYOR."
  5. Repeat for voidai_defi with "Informational only -- not financial advice. DYOR."
- Expected Result: All pass. No false negatives on satellite disclaimers.

---

### Step 5: Howey Test Risk Scoring

**CC-14: Zero prongs triggered**
- Priority: P0
- Description: Content with no Howey triggers scores "none".
- Preconditions: None.
- Steps:
  1. Test: "VoidAI bridge supports cross-chain transfers between Bittensor, Solana, and Ethereum. 99.8% uptime. Not financial advice. DYOR."
- Expected Result: `howey_risk: "none"`. No prongs triggered.

**CC-15: Single prong triggered**
- Priority: P1
- Description: One Howey prong triggers "low" risk.
- Preconditions: None.
- Steps:
  1. Test content mentioning "deposit TAO" (prong 1: investment of money)
- Expected Result: `howey_risk: "low"`. 1 prong triggered.

**CC-16: Two prongs triggered**
- Priority: P0
- Description: Two Howey prongs trigger "medium" risk and auto-escalate to Tier 1.
- Preconditions: None.
- Steps:
  1. Test: "Deposit your TAO into the shared staking pool and receive network rewards."
  2. Prong 1: "deposit" (investment of money), Prong 2: "shared staking pool" (common enterprise)
- Expected Result: `howey_risk: "medium"`, `review_tier: 1` (auto-escalated).

**CC-17: Three or four prongs triggered**
- Priority: P0
- Description: 3-4 prongs trigger "high" risk and compliance failure.
- Preconditions: None.
- Steps:
  1. Test: "Invest your TAO in our shared pool. Our team works to maximize your returns. Earn passive income from network rewards."
  2. Prong 1: "invest" (money), Prong 2: "shared pool" (common enterprise), Prong 3: "returns", "passive income" (profit expectation), Prong 4: "our team works to maximize" (efforts of others)
- Expected Result: `howey_risk: "high"`, `compliance_passed: false`. Content must be rewritten. Note: this content also has Category A violations (invest, passive income, returns) so both systems should catch it.

---

### Step 6: Review Tier Assignment

**CC-18: Tier 1 assignment triggers**
- Priority: P0
- Description: Content meeting any Tier 1 criteria gets Tier 1.
- Preconditions: None.
- Steps: Test content that triggers each Tier 1 criterion:
  1. Mentions "staking rewards" -> Tier 1
  2. Mentions "lending platform" -> Tier 1
  3. Mentions "VOID price" -> Tier 1
  4. Mentions "TVL" -> Tier 1
  5. Blog post (any topic) -> Tier 1 (all blog posts are Tier 1)
  6. New satellite account content (first 30 days) -> Tier 1
  7. Category B red flags present -> Tier 1
  8. Competitor name present -> Tier 1
- Expected Result: `review_tier: 1`, `requires_approval: true` for all.

**CC-19: Tier 2 assignment**
- Priority: P1
- Description: Educational content without financial claims gets Tier 2.
- Preconditions: None.
- Steps:
  1. Test: "How cross-chain bridges work: a technical deep-dive into message verification protocols." (no financial terms, no competitors, pure education)
- Expected Result: `review_tier: 2`. Content auto-queued but subject to 20% spot-check.

**CC-20: Tier 3 assignment**
- Priority: P1
- Description: Memes and community posts with no financial content get Tier 3.
- Preconditions: None.
- Steps:
  1. Test: A meme post for voidai_memes with no financial claims, no token mentions, no yield references. Just: "POV: you just bridged for the first time nfa // dyor"
- Expected Result: `review_tier: 3`. Auto-post allowed (in Phase 4). Still requires disclaimer. Note: During Phase 1a, all content is Tier 1 by policy (first 30 days of satellite accounts).

---

## 3. Template Validation

**TV-01: All 13 templates have correct status field (regression test for audit fix #9)**
- Priority: P0
- Description: Every template must have `status: "drafts"` (plural), not `status: "draft"` (singular).
- Preconditions: Audit fix #9 was applied.
- Steps:
  1. Check the `status` field in each of the 13 templates:
     - `x-single.md`
     - `x-thread.md`
     - `blog-post.md`
     - `linkedin-post.md`
     - `discord-announcement.md`
     - `podcast-notebooklm.md`
     - `video-script.md`
     - `video-google-veo.md`
     - `image-social-graphic.md`
     - `image-content-hero.md`
     - `infographic.md`
     - `data-card.md`
     - `slide-deck.md`
- Expected Result: All 13 templates show `status: "drafts"`.
- Current Status: VERIFIED PASSING. All 13 templates already show `status: "drafts"` (fix was applied).

**TV-02: Account field correctness**
- Priority: P1
- Description: X templates use empty account field (filled at creation time). Non-X templates should also use empty account or be documented as always-v0idai.
- Preconditions: None.
- Steps:
  1. Check `account` field in each template
- Expected Result:
  - `x-single.md`: `account: ""` -- CORRECT
  - `x-thread.md`: `account: ""` -- CORRECT
  - `data-card.md`: `account: ""` -- CORRECT
  - `image-social-graphic.md`: `account: ""` -- CORRECT
  - `blog-post.md`: `account: "v0idai"` -- per audit W6, this is hardcoded. Acceptable IF blog is always v0idai. Document this assumption.
  - `linkedin-post.md`: `account: "v0idai"` -- same as blog
  - `discord-announcement.md`: `account: "v0idai"` -- same
  - `podcast-notebooklm.md`: `account: "v0idai"` -- same
  - `video-script.md`: `account: "v0idai"` -- same
  - `video-google-veo.md`: `account: "v0idai"` -- same
  - `infographic.md`: `account: "v0idai"` -- same
  - `slide-deck.md`: `account: "v0idai"` -- same
  - `image-content-hero.md`: `account: "v0idai"` -- same
- Acceptance: Either (a) `/queue add` always overwrites the template account field with the `--account` parameter, OR (b) templates where satellite accounts could use them (e.g., video-script, infographic) have the hardcode removed. Verify `/queue add` behavior.

**TV-03: Required frontmatter fields present in all templates**
- Priority: P1
- Description: Every template has the full set of required frontmatter fields matching the SKILL.md schema.
- Preconditions: None.
- Steps:
  1. For each of the 13 templates, verify presence of ALL required fields: `id`, `created_at`, `updated_at`, `status`, `previous_status`, `platform`, `account`, `content_type`, `priority`, `scheduled_post_at`, `earliest_post_at`, `latest_post_at`, `pillar`, `character_count`, `has_media`, `thread_count`, `source_workflow`, `generated_by`, `review_tier`, `compliance_passed`, `prohibited_language`, `disclaimer_included`, `risk_level`, `howey_risk`, `red_flags_found`, `compliance_checked_at`, `requires_approval`, `reviewed_by`, `reviewed_at`, `review_notes`, `rejection_reason`, `posted_at`, `post_id`, `failure_reason`, `dry_run`, `stagger_group`, `stagger_order`
- Expected Result: All required fields present. Any template-specific extra fields (e.g., `seo_title` for blog, `video_duration` for video) are also present and correctly typed.

**TV-04: Disclaimer text present in template body**
- Priority: P1
- Description: Each template includes the appropriate default disclaimer text in its content body section.
- Preconditions: None.
- Steps:
  1. Check each template's content body for appropriate disclaimer:
     - X single: short disclaimer present in content section
     - X thread: short disclaimer in final Part N
     - Blog: full long-form disclaimer at bottom
     - LinkedIn: full long-form disclaimer
     - Discord: short disclaimer
     - Video-script: disclaimer in "Disclaimer Frame" section AND in "Accompanying Post Text"
     - Podcast: disclaimer guidance in "Must Avoid" section (audio disclaimer is procedural, not templated text)
     - Image templates: disclaimer in "Accompanying Post Text"
     - Infographic: "Not financial advice. DYOR." in footer + full disclaimer in "Accompanying Post Text"
     - Data card: disclaimer in "Accompanying Post Text"
     - Slide deck: disclaimer on final slide + in "Accompanying Post Text"
- Expected Result: All templates include appropriate disclaimer text. Video and podcast templates include spoken disclaimer guidance per the audit fix #7.

**TV-05: Infographic uses `dimensions` vs `image_dimensions` (audit W13)**
- Priority: P2
- Description: Infographic template uses `dimensions` while image templates use `image_dimensions`. This inconsistency could cause issues in automated processing.
- Preconditions: None.
- Steps:
  1. Check `infographic.md` for field name: `dimensions`
  2. Check `image-social-graphic.md` for field name: `image_dimensions`
  3. Check `image-content-hero.md` for field name: `image_dimensions`
- Expected Result: Document the inconsistency. Recommend standardizing to `image_dimensions` across all templates with a `dimensions` field.

**TV-06: `${SKILL_DIR}` variable in image templates (audit W11)**
- Priority: P1
- Description: Image templates reference `${SKILL_DIR}/scripts/image.py` which only resolves in Claude Code skill execution context.
- Preconditions: None.
- Steps:
  1. Check `image-social-graphic.md` for `${SKILL_DIR}` references
  2. Check `image-content-hero.md` for same
- Expected Result: Document that these commands will fail outside Claude Code. If n8n or manual workflows need to generate images, absolute paths or environment variables must be used instead.

---

## 4. Cadence Rule Testing

**CR-01: Per-account daily limit enforcement**
- Priority: P0
- Description: Scheduling respects max posts/day per account.
- Preconditions: None.
- Steps:
  1. Schedule 2 items for v0idai on 2026-03-17 (the max)
  2. Attempt to schedule a 3rd item for v0idai on 2026-03-17
- Expected Result: 3rd item blocked with message: "v0idai already has 2 posts scheduled for 2026-03-17 (max: 2/day)."

**CR-02: Per-account daily limit for fanpage**
- Priority: P1
- Description: Fanpage account allows up to 2 posts/day (per cadence.md: "1-2").
- Preconditions: None.
- Steps:
  1. Schedule 2 items for voidai_memes on the same day
  2. Attempt a 3rd
- Expected Result: 3rd item blocked. First 2 accepted.

**CR-03: Minimum gap enforcement**
- Priority: P0
- Description: Posts on the same account must respect minimum gap.
- Preconditions: None.
- Steps:
  1. Schedule v0idai post at 14:00 UTC
  2. Attempt v0idai post at 15:00 UTC (only 1 hour gap; requires 3 hours)
  3. Attempt v0idai post at 17:00 UTC (3 hour gap; should pass)
- Expected Result: Step 2 blocked with conflict warning. Step 3 passes. Same test for voidai_memes (2 hour min gap).

**CR-04: Peak window awareness**
- Priority: P1
- Description: Scheduling outside peak windows generates a warning (but does not block).
- Preconditions: None.
- Steps:
  1. Schedule v0idai post at 14:30 UTC (inside peak window 14:00-16:00) -> no warning
  2. Schedule v0idai post at 08:00 UTC (outside all peak windows) -> warning
- Expected Result: Off-peak scheduling shows warning: "Post at 08:00 is outside peak windows (14:00-16:00, 20:00-22:00). Consider rescheduling for better engagement." Post is still allowed.

**CR-05: Weekend limit enforcement**
- Priority: P0
- Description: Max 1 post/day per account on Saturday and Sunday.
- Preconditions: None.
- Steps:
  1. Schedule 1 v0idai post on Saturday -> passes
  2. Attempt 2nd v0idai post on Saturday -> blocked
  3. Schedule 1 voidai_memes post on Sunday -> passes
  4. Attempt 2nd voidai_memes post on Sunday -> blocked
- Expected Result: Weekend limit of 1/day/account enforced.

**CR-06: Stagger group timing enforcement**
- Priority: P1
- Description: Items in a stagger group must respect inter-account timing.
- Preconditions: 4 items in a stagger group. v0idai scheduled at 14:00.
- Steps:
  1. Schedule voidai_memes at 15:00 (only 1 hour after main, requires 2+)
  2. Schedule voidai_memes at 16:00 (2 hours after main, should pass)
  3. Schedule voidai_tao at 16:00 (only 2 hours after main, requires 3+)
  4. Schedule voidai_tao at 17:30 (3.5 hours, should pass)
  5. Schedule voidai_defi at 17:00 (only 3 hours, requires 4+)
  6. Schedule voidai_defi at 18:00 (4 hours, should pass)
- Expected Result: Steps 1, 3, 5 blocked. Steps 2, 4, 6 pass.

**CR-07: 30-minute window restriction**
- Priority: P1
- Description: Never have all satellite accounts active in the same 30-minute window.
- Preconditions: voidai_memes at 16:00, voidai_tao at 16:05.
- Steps:
  1. Schedule voidai_defi at 16:15 (all three satellites in a 15-minute window)
- Expected Result: Warning: "All satellite accounts would be active within a 30-minute window (16:00-16:30). This risks appearing coordinated."

**CR-08: Global 6 posts/day spam limit**
- Priority: P1
- Description: No single account can exceed 6 posts/day (X algorithm spam signal).
- Preconditions: None.
- Steps:
  1. Schedule 6 voidai_memes posts on the same day (will be blocked at 3 by the 2/day fanpage limit first)
- Expected Result: Blocked at 3 (max 2/day for fanpage per cadence.md). If testing with v0idai (2/day limit), verify the global 6/day cap is also enforced separately from per-account limits.

---

## 5. Edge Case Testing

**EC-01: Empty queue operations**
- Priority: P1
- Description: All commands behave gracefully with an empty queue.
- Preconditions: No items in any queue directory.
- Steps:
  1. Run `/queue list`
  2. Run `/queue review`
  3. Run `/queue stats`
  4. Run `/queue calendar`
  5. Run `/queue rebuild`
  6. Run `/queue cleanup`
- Expected Result: Each returns an appropriate "empty" message. No errors, no crashes.

**EC-02: Duplicate content detection (or lack thereof -- audit M7)**
- Priority: P1
- Description: If `/queue add` is run twice with identical content, two separate files are created.
- Preconditions: None.
- Steps:
  1. Run `/queue add --platform x --account v0idai --pillar bridge-build` with identical content body
  2. Run the same command again 5 seconds later with the same content
- Expected Result: Two files with different IDs (different timestamps) created. Document this as a known gap per audit M7. No deduplication exists. Note: for Phase 1a this is acceptable because all content goes through manual review. For Phase 4 (automated n8n workflows), deduplication will be needed.

**EC-03: Missing required frontmatter fields in existing item**
- Priority: P1
- Description: An item with missing frontmatter fields does not crash queue operations.
- Preconditions: Manually create a malformed item in `queue/drafts/` with only `id` and `status` fields.
- Steps:
  1. Run `/queue list`
  2. Run `/queue rebuild`
- Expected Result: Rebuild reports the inconsistency. List either shows the item with missing fields as empty/default or flags it. No crash.

**EC-04: Corrupt manifest.json**
- Priority: P0
- Description: A corrupt or malformed manifest triggers auto-rebuild.
- Preconditions: Replace manifest.json content with `{invalid json`.
- Steps:
  1. Run `/queue list`
- Expected Result: Auto-rebuild triggered. Manifest regenerated from files. List command completes successfully with the rebuilt data.

**EC-05: File in wrong directory vs. status field**
- Priority: P1
- Description: A file with `status: "approved"` physically in `queue/drafts/`.
- Preconditions: Manually create this inconsistency.
- Steps:
  1. Run `/queue rebuild`
- Expected Result: Rebuild detects the mismatch. Moves file to correct directory (`queue/approved/`). Logs the correction.

**EC-06: Very long content body**
- Priority: P2
- Description: Content exceeding normal length (e.g., 10,000 characters for a blog post) is handled.
- Preconditions: None.
- Steps:
  1. Create a blog post with 10,000+ character body via `/queue add`
- Expected Result: File is created and saved. Character count is correct. Compliance checks run on the full body. No truncation of the content file.

**EC-07: Special characters in content**
- Priority: P2
- Description: Content with special characters (emojis, Unicode, YAML-breaking characters like colons in the body) does not corrupt the file.
- Preconditions: None.
- Steps:
  1. Create content with emojis, cashtags ($TAO, $VOID), @mentions, URLs, and YAML special characters (`:`, `#`, `"`, `'`, `|`, `>`, `{`, `}`)
- Expected Result: File is valid YAML+markdown. Content body is preserved exactly. No frontmatter corruption.

**EC-08: Concurrent operations (simulate)**
- Priority: P2
- Description: If two `/queue add` operations happen near-simultaneously (e.g., n8n webhook fires twice), files should not overwrite each other.
- Preconditions: None.
- Steps:
  1. Run two `/queue add` commands in rapid succession (different content)
- Expected Result: Two separate files created with different timestamps. Manifest includes both. No data loss.

**EC-09: Item with nonexistent ID**
- Priority: P1
- Description: Commands referencing a nonexistent ID fail gracefully.
- Preconditions: None.
- Steps:
  1. Run `/queue approve nonexistent-id-12345`
  2. Run `/queue check nonexistent-id-12345`
  3. Run `/queue move nonexistent-id-12345 approved`
- Expected Result: "Item not found: nonexistent-id-12345" for each. No side effects.

---

## 6. SHOULD FIX Items Testing (Audit Items 9-17)

These tests verify whether the pending SHOULD FIX items from the audit create real failures in the current system or are safely deferred.

**SF-01: Batch-approve bypassing Tier 1 gate (audit item 12)**
- Priority: P1
- Description: `/queue batch-approve` currently does not exclude Tier 1 items. This could bypass the mandatory human review gate.
- Preconditions: Item in `queue/review/` with `review_tier: 1`, `compliance_passed: true`, `source_workflow: "daily-metrics"`.
- Steps:
  1. Run `/queue batch-approve --workflow daily-metrics`
  2. Check whether the Tier 1 item is included in the batch
- Expected Result: Document current behavior. If Tier 1 items are included in batch approval, this is a confirmed gap. Workaround for Phase 1a: do not use `/queue batch-approve` until fix is applied. All content goes through individual `/queue review` flow.

**SF-02: `/queue move` compliance reset (audit item 13)**
- Priority: P1
- Description: Moving a rejected item back to drafts should reset compliance fields, but currently does not.
- Preconditions: Rejected item with `compliance_passed: true` from the original check.
- Steps:
  1. Run `/queue move <rejected-id> drafts`
  2. Inspect the file in `queue/drafts/` -- check if compliance fields are preserved or reset
- Expected Result: Document current behavior. If compliance fields are preserved (stale data), this means a reworked item could enter review with outdated compliance results. Workaround: always run `/queue check` manually after moving an item back to drafts.

**SF-03: Status "drafts" in all templates (audit item 9)**
- Priority: P1
- Description: Verify the fix was applied to all 13 templates.
- Preconditions: Fix was applied.
- Steps: (Already covered by TV-01, cross-referenced here)
- Expected Result: All 13 templates show `status: "drafts"`.

**SF-04: Twitter-algorithm-optimizer compliance awareness (audit item 10)**
- Priority: P2
- Description: The optimizer skill may suggest non-compliant optimizations.
- Preconditions: None.
- Steps:
  1. Ask the optimizer to "optimize this tweet about SN106 staking rewards"
  2. Check whether the output contains prohibited language
- Expected Result: Document whether the optimizer reads CLAUDE.md compliance rules. If it produces prohibited terms, this confirms the gap. Workaround: always run `/queue check` on optimizer output.

**SF-05: Content-research-writer queue bypass (audit item 16)**
- Priority: P2
- Description: The content-research-writer skill saves to `~/writing/` instead of the queue system.
- Preconditions: None.
- Steps:
  1. Use the content-research-writer to draft a blog post
  2. Check where the output is saved
- Expected Result: If saved to `~/writing/`, the content bypasses all compliance checks. Workaround: manually copy content into a `/queue add` flow. Long-term fix: redirect the skill to use `/queue add`.

**SF-06: NotebookLM MCP version pinning (audit item 11)**
- Priority: P2
- Description: Verify that `notebooklm-mcp@latest` is the current behavior and document the risk.
- Preconditions: None.
- Steps:
  1. Check `.claude.json` for the NotebookLM MCP version string
- Expected Result: If `@latest`, document as a supply chain risk. The MCP could update with breaking changes. Workaround: pin to current working version.

**SF-07: Reply and quote_tweet template absence (audit item 14)**
- Priority: P1
- Description: Community engagement content (replies, QTs) cannot be created via `/queue add` with proper templates.
- Preconditions: None.
- Steps:
  1. Run `/queue add --platform x --account voidai_tao --type reply --pillar ecosystem-intelligence`
  2. Run `/queue add --platform x --account v0idai --type quote_tweet --pillar bridge-build`
- Expected Result: Document what happens. If the system falls back to x-single.md, the template lacks reply/QT-specific fields (e.g., `reply_to_tweet_id`, `quote_tweet_url`). If it errors, that blocks community engagement workflows.

---

## 7. End-to-End Pipeline Test

**E2E-01: Full lifecycle -- create to calendar verification**
- Priority: P0
- Description: Test the complete content lifecycle from creation through scheduling.
- Preconditions: Queue system operational. CLAUDE.md, voice-learnings.md, content-review-rules.md accessible. Empty queue (or known starting state).
- Steps:
  1. **Create**: Run `/queue add --platform x --account v0idai --pillar bridge-build --type single --priority 3`
     - Provide content: "VoidAI bridge crossed $3M cumulative value bridged this week. 1,400+ unique wallets. SN106 mindshare holding at 2.01% (#5). Building the liquidity layer for Bittensor. Not financial advice. Digital assets are volatile and carry risk of loss. DYOR."
  2. **Verify compliance**: Check that all 6 compliance steps ran automatically.
     - Expected: `prohibited_language: "pass"`, `disclaimer_included: true`, `howey_risk: "none"`, `review_tier: 1` (mentions TVL/metrics)
  3. **Verify auto-advance**: File should be in `queue/review/` with status "review", not in drafts.
  4. **Review card**: Verify in-chat review card is displayed with all required fields.
  5. **Approve**: Respond "approve" or run `/queue approve <id> --notes "Good data-driven post"`
     - Verify: file moves to `queue/approved/`, status updated, reviewed_by set
  6. **Schedule**: Run `/queue schedule <id> --at "2026-03-17T14:30:00Z"`
     - Verify: cadence validation runs, no conflicts, file moves to `queue/scheduled/`
  7. **Calendar**: Run `/queue calendar --days 7`
     - Verify: the scheduled item appears on the correct day/time
  8. **Stats**: Run `/queue stats`
     - Verify: counts reflect the current state, pillar distribution updated
  9. **Manifest**: Open `manifest.json` and verify the item entry matches the file's frontmatter
- Expected Result: Complete lifecycle works end-to-end without manual intervention at any step (except the human approval). Each transition updates all relevant fields. Manifest stays in sync throughout.

**E2E-02: Full lifecycle -- rejection and rework cycle**
- Priority: P0
- Description: Test the rejection, rework, and re-submission flow.
- Preconditions: None.
- Steps:
  1. **Create and review**: `/queue add` a post. Review card appears.
  2. **Reject**: "reject: too generic, needs specific bridge volume numbers"
     - Verify: file in `queue/rejected/`, `rejection_reason` populated
  3. **Rework**: `/queue move <id> drafts`
     - Verify: file moves to `queue/drafts/`, status updated
     - Check: are compliance fields reset? (Document per SF-02)
  4. **Re-check**: `/queue check <id>` (to run fresh compliance)
  5. **Re-submit**: `/queue move <id> review`
     - Verify: file in `queue/review/`
  6. **Re-review**: `/queue review` -- card should show the reworked content
  7. **Approve**: approve the reworked version
- Expected Result: Full rejection-rework cycle completes. Compliance fields are fresh (from Step 4 re-check). The item ends up in `approved/` with full audit trail (previous_status chain, review timestamps).

**E2E-03: Multi-account stagger group lifecycle**
- Priority: P1
- Description: Test coordinated multi-account posting from creation to scheduling.
- Preconditions: None.
- Steps:
  1. Create 4 content items, one per account, all about the same news (e.g., new chain integration):
     - v0idai: official announcement
     - voidai_memes: meme angle
     - voidai_tao: ecosystem impact angle
     - voidai_defi: infrastructure alpha angle
  2. Review and approve all 4
  3. Create stagger group: `/queue stagger chain-launch --items <id1>,<id2>,<id3>,<id4>`
  4. Schedule the main @v0idai post at 14:00 UTC
  5. Schedule remaining items respecting stagger timing
  6. Verify calendar shows the staggered schedule
- Expected Result: Stagger group created with correct order. Scheduling enforces minimum delays. Calendar shows 4 posts staggered across the day. No two satellite accounts post within 30 minutes of each other.

**E2E-04: DRY_RUN flag verification**
- Priority: P0
- Description: Verify that `dry_run: true` in manifest and all items prevents any external posting.
- Preconditions: `manifest.json` has `dry_run_mode: true`.
- Steps:
  1. Verify `manifest.json` field `dry_run_mode: true`
  2. Check that all content items have `dry_run: true` in frontmatter
  3. Verify that the n8n integration spec (SKILL.md lines 533-534) says: when `dry_run: true`, logs output and moves to `posted/` with `post_id: "DRY_RUN"`
- Expected Result: DRY_RUN is enabled system-wide. No external API calls are made. All posting is simulated. This is the correct state for Phase 1a testing.

**E2E-05: Blog post derivative pipeline (simulate)**
- Priority: P1
- Description: Blog post creation triggers derivative content needs.
- Preconditions: None.
- Steps:
  1. `/queue add --platform blog --account v0idai --pillar alpha-education --type article`
  2. Verify the blog template includes `derivatives_needed: true` and `derivative_formats: ["x-thread", "linkedin-post", "discord-announcement"]`
  3. After the blog post is approved, verify the system identifies that derivative content should be created
  4. Create each derivative via `/queue add` with appropriate types
- Expected Result: Blog post has derivative metadata. Derivative creation workflow is manual for Phase 1a (automated via Workflow 5 in Phase 3). Each derivative goes through its own compliance check and review cycle.

**E2E-06: Compliance failure rewrite lifecycle (most common failure path)**
- Priority: P0
- Description: Test the full lifecycle of content that fails compliance, gets rewritten, and re-enters the pipeline. This is the most common failure path during real content creation.
- Preconditions: Queue system operational. Compliance checks functional.
- Steps:
  1. **Create with prohibited term**: Run `/queue add --platform x --account v0idai --pillar bridge-build --type single`
     - Provide content containing a prohibited term: "VoidAI staking offers guaranteed returns. Bridge your TAO today. DYOR."
  2. **Verify compliance blocks**: Compliance auto-runs during `/queue add`. Verify `prohibited_language: "fail"`, `compliance_passed: false`. The term "guaranteed returns" must trigger Category A failure.
  3. **Verify content is blocked**: Content should NOT advance to `queue/review/`. Verify it remains in `queue/drafts/` or is blocked from entering the pipeline entirely. Document the exact blocking behavior.
  4. **Rewrite content**: Create corrected version with compliant language: "VoidAI network participation offers variable rate rewards. Bridge your TAO today. Not financial advice. Digital assets are volatile and carry risk of loss. DYOR."
  5. **Re-run compliance**: Run `/queue check <id>` on the rewritten content (or `/queue add` with new content if the original was blocked entirely).
  6. **Verify compliance passes**: `prohibited_language: "pass"`, `compliance_passed: true`. The `compliance_passed` field must flip from false to true.
  7. **Verify advancement to review**: Content should now advance to `queue/review/` and present a review card.
  8. **Approve**: Approve the compliant content. Verify it moves to `queue/approved/`.
- Expected Result: The compliance-failure-rewrite cycle works end-to-end. Prohibited content is blocked. Rewritten content passes. The `compliance_passed` field correctly reflects the latest check. Content successfully enters review after rewrite. This validates the most likely failure path during Phase 1a content production.

---

## 8. Regression Testing (9 Applied Fixes)

These tests verify that the 8 critical fixes identified in the challenger verdict (plus template status fix) are working correctly.

**RG-01: Taostats API key rotated (audit fix #1)**
- Priority: P0
- Description: The old key should no longer work. New key should be in an environment variable.
- Preconditions: Key rotation was performed.
- Steps:
  1. Verify `$TAOSTATS_API_KEY` environment variable is set (without printing the value)
  2. Verify `.claude.json` no longer contains the plaintext key `tao-104ff5b2-c47e-42f0-9115-2bdddbb7cda3:fb7c4f1a`
  3. Verify the audit report in `reviews/AUDIT-mcp-integrations.md` has the key redacted
- Expected Result: Old key not present in plaintext. Environment variable set. Audit report redacted.

**RG-02: GEMINI_API_KEY set (audit fix #2)**
- Priority: P0
- Description: The Gemini API key for Nano Banana Pro image generation is configured.
- Preconditions: Key was set.
- Steps:
  1. Verify `$GEMINI_API_KEY` environment variable is set (without printing the value)
  2. Attempt a test image generation using the image-social-graphic template workflow
- Expected Result: Environment variable is set. Image generation does not fail with auth errors.

**RG-03: NotebookLM active notebook set to voidai (audit fix #3)**
- Priority: P0
- Description: NotebookLM MCP points to the VoidAI notebook, not nodexo-ai.
- Preconditions: Fix was applied.
- Steps:
  1. Check `~/Library/Application Support/notebooklm-mcp/library.json` for `active_notebook_id`
- Expected Result: `active_notebook_id: "voidai"` (not "nodexo-ai").

**RG-04: Disclaimer check accepts account-specific variants (audit fix #4)**
- Priority: P0
- Description: The compliance Step 4 lookup table now maps each account to its acceptable disclaimer variants.
- Preconditions: Fix was applied.
- Steps: (Covered by CC-11 and CC-13, cross-referenced here)
- Expected Result: All satellite account disclaimers pass the check.

**RG-05: "allocation" and "airdrop" in CLAUDE.md prohibitions (audit fix #5)**
- Priority: P0
- Description: These terms now appear in CLAUDE.md Absolute Prohibitions.
- Preconditions: Fix was applied.
- Steps:
  1. Search CLAUDE.md for "allocation" in the Absolute Prohibitions section
  2. Search CLAUDE.md for "airdrop" in the Absolute Prohibitions section
  3. Test content: "Complete tasks to receive the VoidAI airdrop and your token allocation"
  4. Run compliance check on this content
- Expected Result: Both terms found in CLAUDE.md. Compliance check flags the content with `prohibited_language: "fail"`, `compliance_passed: false`.

**RG-06: "My play today:" removed from DeFi persona (audit fix #6)**
- Priority: P0
- Description: The DeFi satellite account persona no longer uses "My play today:" format.
- Preconditions: Fix was applied.
- Steps:
  1. Search CLAUDE.md for "My play today"
  2. Verify it has been replaced with "What I'm watching today:" or similar non-position format
- Expected Result: "My play today:" not present in CLAUDE.md. Replacement format does not imply a personal financial position.

**RG-07: Video and podcast disclaimer templates added (audit fix #7)**
- Priority: P0
- Description: CLAUDE.md now includes disclaimer templates for video and podcast content. Queue-manager Step 4 now includes these platforms in its check.
- Preconditions: Fix was applied.
- Steps:
  1. Search CLAUDE.md Required Disclaimers section for video disclaimer template
  2. Search for podcast disclaimer template
  3. Verify queue-manager SKILL.md Step 4 includes video and podcast in the disclaimer lookup table
  4. Test: create a video-script content item and verify disclaimer check works
- Expected Result: Video disclaimer: "This content is for informational purposes only and does not constitute financial advice." (or equivalent in script body + description). Podcast disclaimer present in CLAUDE.md. Step 4 checks both.

**RG-08: Audit reports moved out of queue/drafts/ (audit fix #8)**
- Priority: P0
- Description: The 4 audit reports are no longer in `queue/drafts/` where they would interfere with `/queue rebuild`.
- Preconditions: Reports were moved to `reviews/` or similar.
- Steps:
  1. Check `queue/drafts/` for any AUDIT-*.md files
  2. Check that `reviews/` contains the audit reports
  3. Run `/queue rebuild` and verify no errors from non-content files
- Expected Result: No audit reports in `queue/drafts/`. Rebuild runs cleanly.

**RG-09: Template status field fix (audit fix #9, same as TV-01)**
- Priority: P0
- Description: All 13 templates use `status: "drafts"` (plural).
- Preconditions: Fix was applied.
- Steps: (Same as TV-01)
- Expected Result: All 13 templates verified as `status: "drafts"`.

---

## 9. Improvements and Gaps

Issues discovered during test plan creation that are not covered by existing tests or audit findings.

**GAP-01: No `/queue pause` or `/queue resume` command**
- Priority: P1
- Description: The crisis communication protocol in CLAUDE.md says "PAUSE all scheduled content across ALL accounts immediately" but there is no queue command to do this. All 4 audit reports flagged this independently.
- Recommendation: Build `/queue pause` (sets `crisis_mode: true` in manifest, prevents all scheduling and posting) and `/queue resume` (lifts the flag). This is a SHOULD FIX before soft launch per audit consensus.
- Test Case: Once built, test that pause prevents scheduling, prevents n8n from picking up scheduled items, and resume restores normal operation.

**GAP-02: No character limit enforcement**
- Priority: P2
- Description: The review card shows `{character_count} / {limit}` but no `character_limit` field exists in templates, and no compliance step rejects content for being too long. A 500-character tweet would pass all checks.
- Recommendation: Add `character_limit` field to templates (280 for X single, 4000 for X Premium, 3000 for LinkedIn, etc.). Add a compliance check step (or warning in review card) when content exceeds the limit.
- Test Case: Create a 400-character X single post. Verify the review card shows the count vs. limit and flags the overage.

**GAP-03: No rollback capability for queue operations**
- Priority: P2
- Description: If `/queue approve` or `/queue move` makes an incorrect transition, there is no undo. The user must manually reverse with another `/queue move`.
- Recommendation: Consider adding `/queue undo` that reverses the last operation using the `previous_status` field. Low priority -- manual reversal works fine.

**GAP-04: Pillar distribution drift not tested during scheduling**
- Priority: P1
- Description: The SKILL.md states pillar distribution warnings appear on `/queue add`, `/queue stats`, and `/queue calendar` when any pillar drifts >5% from target. This is not tested during `/queue schedule`.
- Recommendation: Add a test case for pillar drift warnings. If bridge-build is at 60% (target: 40%, drift: +20%), the warning should appear when adding or scheduling more bridge-build content.
- Test Case:
  1. Create 5 bridge-build items and 0 items for other pillars
  2. Run `/queue stats`
  3. Verify warning: "bridge-build at 100% (target: 40%, +60% drift)"

**GAP-05: Compliance check on content body vs. frontmatter fields**
- Priority: P1
- Description: The compliance scanner checks the content body for prohibited terms, but does not check frontmatter metadata fields like `review_notes`, `seo_title`, `seo_description`. If prohibited language appears in the SEO description, it would be published on the website but not caught by the scanner.
- Recommendation: Extend the Category A scan to include `seo_title`, `seo_description`, and any other published metadata fields.
- **Clarification (from challenger review):** This is a confirmed real gap. The SEO plan (Section 6, Blog SEO Template) routes `seo_title` and `seo_description` through the queue system frontmatter, but these fields are never scanned by compliance. The gap is specifically about *published* metadata -- `review_notes` is internal and does not need scanning, but `seo_title` and `seo_description` appear in HTML meta tags visible to users and search engines. Cross-reference: SEO plan SEO-06 independently identifies this same gap from the SEO side.

**GAP-06: No test for n8n-generated content entering the queue**
- Priority: P2
- Description: The SKILL.md describes n8n writing `.md` files to `queue/drafts/` with compliance fields left as unchecked. There is no test verifying that n8n-generated files are correctly parsed, have the right schema, and get compliance-checked when they enter review.
- Recommendation: Create a mock n8n-generated file with `generated_by: "n8n"`, `source_workflow: "daily-metrics"`, and minimal frontmatter. Test that `/queue rebuild` picks it up and that compliance checks run when it is moved to review.

**GAP-07: Manifest `scheduled_post_at` schema inconsistency (audit M4)**
- Priority: P2
- Description: The manifest schema lists `scheduled_post_at` as a required field in items, but non-scheduled items omit it rather than setting it to `null`. This violates strict JSON schema validation.
- Recommendation: Set `scheduled_post_at: null` for non-scheduled items in the manifest. Not blocking for Phase 1a but will matter for Notion migration.

**GAP-08: No testing of prompt injection safeguards**
- Priority: P1
- Description: CLAUDE.md includes a full prompt injection safeguards section, but there is no queue-level test for sanitization of user-generated content when it enters the queue (e.g., via community engagement replies that contain instruction injection attempts).
- Recommendation: Test that content containing "ignore previous instructions" or similar patterns is flagged for human review rather than processed normally.

**GAP-09: No compliance check on content changes after initial check**
- Priority: P1
- Description: If content is checked at creation time but then modified (e.g., via "edit: feedback" in the review flow), the compliance results become stale. There is no mechanism to force a re-check after content modifications.
- Recommendation: Any content modification should trigger a re-check, or at minimum set `compliance_passed: false` and `prohibited_language: "unchecked"` to force manual re-verification.

**GAP-10: Satellite account 30-day Tier 1 enforcement**
- Priority: P1
- Description: CLAUDE.md and content-review-rules.md specify that all content for the first 30 days of a new satellite account must be Tier 1. There is no mechanism in the queue system to track when an account was created or to enforce this time-based rule.
- Recommendation: Add an `account_created_at` field or a config file mapping accounts to their creation dates. The compliance Step 6 should check if the account is less than 30 days old and force Tier 1 if so.
- **Clarification (from challenger review):** This is an implementation gap, not a missing rule. The compliance rule itself EXISTS in SKILL.md Step 6 (line 437): "All content for first 30 days of any new satellite account" triggers Tier 1. What is missing is the date-tracking mechanism to enforce it. During Phase 1a, this is a non-issue because all satellite accounts are new and all content will be Tier 1 by default. The gap becomes real after the 30-day mark when the system needs to know whether to downgrade accounts to Tier 2/3.

---

## Test Execution Checklist

| ID Range | Category | Total Tests | P0 | P1 | P2 |
|-----------|----------|:-----------:|:--:|:--:|:--:|
| QS-01 to QS-42 (+ QS-26b, QS-26c) | Queue System Commands | 44 | 16 | 18 | 10 |
| CC-01 to CC-20 | Compliance Checks | 20 | 11 | 7 | 2 |
| TV-01 to TV-06 | Template Validation | 6 | 1 | 4 | 1 |
| CR-01 to CR-08 | Cadence Rules | 8 | 3 | 5 | 0 |
| EC-01 to EC-09 | Edge Cases | 9 | 1 | 5 | 3 |
| SF-01 to SF-07 | SHOULD FIX Items | 7 | 0 | 4 | 3 |
| E2E-01 to E2E-06 | End-to-End Pipeline | 6 | 4 | 2 | 0 |
| RG-01 to RG-09 | Regression (Applied Fixes) | 9 | 9 | 0 | 0 |
| GAP-01 to GAP-10 | Improvements/Gaps | 10 | 0 | 6 | 4 |
| **TOTAL** | | **119** | **45** | **51** | **23** |

### Execution Order

1. **Regression tests first (RG-01 through RG-09)**: Verify all 9 applied fixes are working before testing anything else. If any regression test fails, stop and re-apply the fix.

2. **Template validation (TV-01 through TV-06)**: Quick structural checks that do not require running queue commands.

3. **Compliance checks (CC-01 through CC-20)**: Verify the compliance engine works before testing commands that depend on it.

4. **Queue commands -- P0 only (QS-01, QS-02, QS-03, QS-04, QS-06, QS-10, QS-14, QS-16, QS-18, QS-19, QS-26, QS-26b, QS-29, QS-33, QS-34)**: Core command functionality.

5. **Cadence rules (CR-01, CR-03, CR-05 first, then remaining)**: Scheduling safety.

6. **End-to-end pipeline (E2E-01 through E2E-06)**: Full lifecycle after individual components verified. E2E-06 (compliance failure rewrite) is P0 and tests the most common failure path.

7. **Edge cases and SHOULD FIX items**: After core functionality is verified.

8. **P1 and P2 tests**: Remaining tests in priority order.

### Sign-Off Template

| Category | Tested By | Date | Pass/Fail | Notes |
|----------|-----------|------|-----------|-------|
| Regression (RG) | | | | |
| Templates (TV) | | | | |
| Compliance (CC) | | | | |
| Queue Commands (QS) | | | | |
| Cadence Rules (CR) | | | | |
| End-to-End (E2E) | | | | |
| Edge Cases (EC) | | | | |
| SHOULD FIX (SF) | | | | |
| Gaps Identified (GAP) | | | | |
| **OVERALL** | | | | |

---

*This test plan covers the complete VoidAI content queue pipeline for Phase 1a system validation. All P0 tests must pass before any content is created for soft launch. P1 tests should pass before DRY_RUN is set to false. P2 tests are tracked for future phases.*

---

## Corrections Applied

Corrections from challenger report (`reviews/phase1a-challenger-technical.md`), applied 2026-03-13.

| # | Challenger Finding | Section Changed | What Was Fixed |
|---|-------------------|-----------------|----------------|
| 1 | **ST-05 (CRITICAL):** QS-03 priority misassignment | QS-03 | Upgraded from P1 to P0. Missing template fallback can crash the system or produce corrupt output, meeting the P0 definition ("core functionality is broken"). Per AUDIT-challenger-verdict.md (M1): "runtime error waiting to happen." |
| 2 | **ST-05 (CRITICAL):** SF-01 priority misassignment | SF-01 | Downgraded from P0 to P1. The documented workaround (do not use `/queue batch-approve`, review all content individually via `/queue review`) makes this a P1 ("can be worked around manually"), not a P0 blocker. |
| 3 | **ST-08 (CRITICAL):** CC-06 expected result is wrong | CC-06 | Replaced the ambiguous "may or may not distinguish context" expected result with a precise statement: Category A scan is text-matching only and CANNOT distinguish educational from promotional context. "yield" without "variable" qualifier triggers Category A failure regardless of context. Human review at Tier 1 provides the context judgment. This is by design. |
| 4 | **ST-10 (CRITICAL):** Missing E2E test for compliance failure rewrite lifecycle | Section 7, E2E-06 (new) | Added P0 test case E2E-06: content with prohibited term -> compliance auto-blocks -> rewrite with compliant language -> re-run `/queue check` -> `compliance_passed` flips to true -> advance to review -> approve. This is the most common failure path during content creation. |
| 5 | **ST-01:** `/queue check` undertested as standalone command | QS-26b, QS-26c (new) | Added QS-26b (P0): verify frontmatter is actually persisted to disk after check runs. Added QS-26c (P1): verify re-check produces fresh results after content is edited, not cached. |
| 6 | **ST-06:** GAP-05 and GAP-10 partially mischaracterized | GAP-05, GAP-10 | Added clarifying notes. GAP-05: clarified that `review_notes` is internal (no scan needed) but `seo_title`/`seo_description` are published metadata that bypass the scanner. Cross-referenced SEO plan SEO-06. GAP-10: clarified that the compliance RULE exists in SKILL.md but the date-tracking MECHANISM is missing. Non-issue during Phase 1a since all accounts are new. |
| 7 | **Checklist update** | Test Execution Checklist, Execution Order | Updated totals: 116 -> 119 tests. P0: 43 -> 45. P1: 50 -> 51. Updated QS row (42->44, P0 14->16), SF row (P0 1->0, P1 3->4), E2E row (5->6, P0 3->4). Updated execution order to include QS-03, QS-26b, and E2E-06 in P0 runs. |
