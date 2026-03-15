# /subnet-spotlight

Generate a spotlight thread about a non-VoidAI Bittensor subnet to build ecosystem credibility.

## Trigger
When the user says: "subnet spotlight", "spotlight subnet", "/subnet-spotlight"

## Instructions

1. **Load config:**
   - Read `CLAUDE.md` for rules
   - Read `companies/voidai/voice.md`
   - Read `engine/templates/x-thread.md`

2. **Gather inputs:**
   - Subnet name (required)
   - Subnet number (required, e.g., SN64)
   - Brief description of what it does (optional, will research if not provided)

3. **Research the subnet:**
   - Search web for current info about the subnet
   - Find: what it does, team/founders, current metrics (emissions, miners, validators), recent milestones
   - Check Taostats for current data if MCP available
   - Verify all data is current

4. **Generate 5-7 tweet thread:**
   - Part 1: Hook introducing the subnet and why it matters
   - Parts 2-4: What it does, how it works, key metrics
   - Part 5-6: Why it matters for Bittensor ecosystem
   - Final part: Links to learn more (their docs, Taostats page)

5. **Critical rules:**
   - ZERO VoidAI mentions (this is about the ecosystem, not us)
   - Genuine, respectful tone. Not promotional.
   - Data-driven. Include real metrics.
   - Tag the subnet's official X account if known
   - Use "Bittensor Ecosystem" framing, not VoidAI branding
   - Reference Canva subnet spotlight template (ID: DAHEDZjUQ_E) for image

6. **Compliance:**
   - Standard checks (banned phrases, em dashes, char limits)
   - No financial claims about the subnet's token
   - "Not financial advice" if discussing token economics

7. **Output:**
   - Write to `companies/voidai/queue/drafts/{YYYYMMDD}-subnet-spotlight-{name}.md`
   - Tag with pillar: ecosystem-intelligence
   - account: v0idai
