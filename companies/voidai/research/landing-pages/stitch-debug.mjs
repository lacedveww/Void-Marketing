import { StitchToolClient } from "@google/stitch-sdk";

const client = new StitchToolClient({ apiKey: process.env.STITCH_API_KEY });

const tools = await client.listTools();
console.log(JSON.stringify(tools, null, 2));
await client.close();
