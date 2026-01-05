/**
 * Import function triggers from their respective submodules:
 *
 * import {onCall} from "firebase-functions/v2/https";
 * import {onDocumentWritten} from "firebase-functions/v2/firestore";
 *
 * See a full list of supported triggers at https://firebase.google.com/docs/functions
 */

import { setGlobalOptions } from "firebase-functions";
import { onRequest } from "firebase-functions/https";
import * as logger from "firebase-functions/logger";
import axios from "axios";
import functions from "firebase-functions";

// Start writing functions
// https://firebase.google.com/docs/functions/typescript

// For cost control, you can set the maximum number of containers that can be
// running at the same time. This helps mitigate the impact of unexpected
// traffic spikes by instead downgrading performance. This limit is a
// per-function limit. You can override the limit for each function using the
// `maxInstances` option in the function's options, e.g.
// `onRequest({ maxInstances: 5 }, (req, res) => { ... })`.
// NOTE: setGlobalOptions does not apply to functions using the v1 API. V1
// functions should each use functions.runWith({ maxInstances: 10 }) instead.
// In the v1 API, each function can only serve one request per container, so
// this will be the maximum concurrent request count.
setGlobalOptions({ maxInstances: 10 });

// export const helloWorld = onRequest((request, response) => {
//   logger.info("Hello logs!", {structuredData: true});
//   response.send("Hello from Firebase!");
// });

exports.analyzeImage = functions.https.onRequest(async (req, res) => {
    try {
        const { imageBase64, prompt } = req.body
        if (!imageBase64) {
            res.status(400).json({ error: "The image must be Base64 format" })
            return
        }

        const response = await axios.post(
            "https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash-lite:generateContent",
            {
                contents: [
                    {
                        parts: [
                            { text: prompt || "Analyze this image" },
                            {
                                inline_data: {
                                    mime_type: "image/jpeg",
                                    data: imageBase64
                                }
                            }
                        ]
                    }
                ]
            },
            {
                headers: {
                    "Content-Type": "application/json",
                    "X-Goog-Api-Key": process.env.API_KEY
                }
            }
        )

        const result = response.data.candidates?.[0]?.content?.parts?.[0]?.text || ""
        res.json({ result })
        return
    } catch (error) {
        console.error((error as any).response?.data || (error as any).message)
        res.status(500).json({ error: "Gemini error" })
        return
    }
})
