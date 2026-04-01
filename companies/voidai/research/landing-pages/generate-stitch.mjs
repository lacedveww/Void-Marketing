import { StitchToolClient } from "@google/stitch-sdk";
import { writeFileSync, mkdirSync } from "fs";

const client = new StitchToolClient({
  apiKey: process.env.STITCH_API_KEY
});

mkdirSync("stitch-output", { recursive: true });

// ONE project for everything
console.log("Creating single project...");
const project = await client.callTool("create_project", { title: "Void Rebrand - 3 Landing Pages" });
const projectId = project.name.split("/")[1];
console.log("Project ID:", projectId);

// Completely original prompts — NO reference to HTML layouts or existing designs
const designs = [
  {
    name: "void-capital",
    prompt: `Create an original desktop landing page for a premium institutional DeFi lending company called "Void Capital".

BRAND: Void Capital is the Goldman Sachs of DeFi. It targets hedge funds, treasuries, and institutional allocators who want to earn yield on their capital through decentralized lending.

VISUAL DIRECTION: Think private bank meets modern fintech. Serif typography for headlines. Clean sans-serif for body. Monospace for financial data. Generous whitespace. No crypto cliches. No neon. No gradients. This should look like it belongs on Wall Street, not in a Discord server.

COLORS: Steel blue #475569 as the primary brand color. Dark charcoal #1E293B for headlines. Silver grey #94A3B8 for accents. White #FFFFFF backgrounds. Use the steel blue sparingly for buttons and key data points only.

KEY CONTENT TO INCLUDE:
- Company name "VOID CAPITAL" in a serif font
- Headline about institutional DeFi lending
- Current yield rate: 8.2% APY (display prominently)
- Trust metrics: $127M total deposits, 99.9% uptime, SOC 2 Type 2 certified
- Three key offerings: Treasury Management, Yield Optimization, Compliance
- A comparison showing traditional bank rate (0.5%) vs Void Capital rate (8.2%)
- Security credentials and audit information
- A "Schedule a Consultation" call to action

FEEL: Quiet confidence. Authority through restraint. Every element should feel intentional and expensive. If Goldman Sachs redesigned their website as a DeFi platform, this is what it would look like.`
  },
  {
    name: "void-minimal",
    prompt: `Create an original desktop landing page for "void." (lowercase, with a period) — an ultra-minimal consumer DeFi lending platform.

BRAND: void. is the Stripe of DeFi. Radical simplicity. The design philosophy is: if it can be removed, remove it. The page should feel 80% empty space. No clutter. No decoration. No icons unless absolutely necessary. The confidence comes from what is NOT on the page.

VISUAL DIRECTION: One typeface only (geometric sans-serif like Inter). Two colors maximum: charcoal #1E293B for text and steel blue #475569 ONLY for the period in the logo and CTA buttons. Everything else is white space.

COLORS: Pure white #FFFFFF background. Charcoal #1E293B text. Steel blue #475569 accent used only for: the dot in "void.", buttons, and the yield number.

KEY CONTENT TO INCLUDE:
- Logo: just the word "void." in lowercase with a steel blue period
- Hero headline: "Simply earn." (large, centered, lots of space around it)
- One-liner: "Deposit crypto. Earn interest. That's it."
- Single "Start Earning" button
- Rate comparison: bank 0.5% vs void. 8.2%
- Three steps: Connect, Deposit, Earn (just text, no icons)
- An interactive yield calculator showing returns on deposit amounts
- Trust numbers: 12,847 depositors, $127M secured
- Footer with "void." logo

FEEL: A breath of fresh air. Like walking into a perfectly empty white room with one beautiful piece of furniture. The anti-crypto-website. Someone should be able to read the entire page in 15 seconds. Every word earns its place.`
  },
  {
    name: "void-labs",
    prompt: `Create an original desktop landing page for "Void Labs" — the technical builder team behind a DeFi lending protocol on Bittensor blockchain.

BRAND: Void Labs is the engineering powerhouse. Think Vercel or Supabase — developer-loved companies that ship fast and communicate through their work. The brand is "we built it, it works, here's the proof."

VISUAL DIRECTION: Developer aesthetic. Dark code blocks with syntax highlighting. Terminal commands. Status badges ("Live", "Shipped"). Monospace font for data and code. Clean sans-serif for everything else. The page should feel like a well-designed developer docs site crossed with a product landing page.

COLORS: Steel blue #475569 for "LABS" text and primary buttons. Charcoal #1E293B for "VOID" text and dark sections. Silver #94A3B8 for secondary elements. White backgrounds for main content. Dark charcoal backgrounds for metrics and code sections.

KEY CONTENT TO INCLUDE:
- Logo: "VOID" in bold charcoal + "LABS" in steel blue, with a small VL monogram
- Headline: "We build. You earn." (second part in steel blue)
- A terminal/code block showing: npm install @void/sdk with usage example
- Product stack showing three shipped products: Bridge (Live), Staking (Live), Lending (Coming Soon)
- Live metrics dashboard: $127M bridged, 482K transactions, 99.9% uptime, 4 chains
- Builder timeline: 2024 Bridge shipped, 2025 Staking shipped, 2026 Lending in progress
- Security section: Chainlink CCIP, non-custodial, audited, open source
- Developer CTA with SDK code example
- Chains supported: Bittensor, Ethereum, Solana, Base

FEEL: "These people ship." Every section proves execution. Past tense for what's done, present tense for what's building. Technical credibility without being intimidating. A developer should look at this page and think "I trust these people with my integration."`
  }
];

// Generate all 3 screens in the SAME project
for (const design of designs) {
  try {
    console.log(`\n=== Generating: ${design.name} ===`);

    const result = await client.callTool("generate_screen_from_text", {
      projectId: projectId,
      prompt: design.prompt,
      deviceType: "DESKTOP",
      modelId: "GEMINI_3_FLASH"
    });

    // Log what we got back
    const resultStr = JSON.stringify(result, null, 2);
    writeFileSync(`stitch-output/${design.name}-response.json`, resultStr);
    console.log(`Response saved to stitch-output/${design.name}-response.json`);
    console.log(`Output components: ${result?.outputComponents?.length || 0}`);

    // Check for screen data
    if (result?.outputComponents) {
      for (const comp of result.outputComponents) {
        if (comp.screen) {
          console.log(`Screen found: ${comp.screen.name || comp.screen.screenId || 'unknown'}`);
        }
        if (comp.designSystem) {
          console.log(`Design system: ${comp.designSystem.designSystem?.displayName || 'unnamed'}`);
        }
      }
    }

  } catch (err) {
    console.error(`Error [${design.name}]:`, err.message);
  }
}

// Now list all screens in the project
console.log("\n=== Listing all screens in project ===");
try {
  const screens = await client.callTool("list_screens", { projectId: projectId });
  const screensStr = JSON.stringify(screens, null, 2);
  writeFileSync("stitch-output/all-screens.json", screensStr);
  console.log(`Screens response saved. Keys: ${Object.keys(screens)}`);

  if (screens.screens && screens.screens.length > 0) {
    console.log(`Found ${screens.screens.length} screens!`);
    for (const screen of screens.screens) {
      console.log(`  Screen: ${screen.name} - ${screen.displayName || 'untitled'}`);
    }
  } else {
    console.log("No screens found yet (may still be generating)");
  }
} catch (err) {
  console.error("List screens error:", err.message);
}

await client.close();
console.log("\nDone! Check stitch-output/ for responses.");
console.log(`Project URL: https://stitch.withgoogle.com/project/${projectId}`);
