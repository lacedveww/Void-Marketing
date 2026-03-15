# /data-card

Generate a daily metrics data card tweet with Canva image spec for VoidAI.

## Trigger
When the user says: "data card", "daily metrics", "generate data card", "/data-card"

## Instructions

1. **Load config:**
   - Read `CLAUDE.md` for rules
   - Read `companies/voidai/voice.md`
   - Read `companies/voidai/design-system.md` for visual specs
   - Read `engine/templates/data-card.md` for template

2. **Gather metrics** (ask user or fetch via MCP):
   - Bridge Volume (24h)
   - SN106 TVL
   - TAO Price (current)
   - wTAO Supply
   - SN106 Emissions Rank
   - Any notable metric change (flag if > 10% daily move)

3. **Generate tweet text:**
   - Under 280 characters
   - Lead with the most interesting metric
   - Format: clean, data-first, minimal commentary
   - Example: "VoidAI Daily | Mar 15\n\nBridge Vol: $X\nTVL: $X\nTAO: $X (+X%)\nSN106 Rank: #X\n\napp.voidai.com/bridge-chains"

4. **Generate Canva image spec:**
   - Include in ## Image Spec section
   - Background: #0A0A0F
   - Typography: Space Grotesk for numbers, Inter for labels
   - Layout: 4-6 metric boxes in grid
   - Colors: blue for bridge, green for TVL, purple for TAO, amber for rank
   - Reference the data card template in Canva (ID: DAHEDQSTwcA)

5. **Data freshness:**
   - ALL numbers must be real, current data
   - If any metric unavailable, show "N/A" and flag in editor notes
   - Never estimate or use stale data

6. **Output:**
   - Write to `companies/voidai/queue/drafts/{YYYYMMDD}-datacard.md`
   - Tag with pillar: bridge-build
   - has_media: true
