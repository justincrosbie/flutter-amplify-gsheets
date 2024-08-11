import AWS from 'aws-sdk';
import { google } from 'googleapis';

const sheets = google.sheets('v4');

const secretName = "hudom_gsheets";
const region = "us-east-1"; // replace with your AWS region
const spreadsheetId = "1NDEQpVpIY33rnSCyXql5yIZXrQsBkDjkfmleemP7JdY";
const range = 'Sheet1!A1:D10';

export const handler = async (event) => {
    try {

        const secretsManager = new AWS.SecretsManager({ region });

        const secret = await secretsManager.getSecretValue({ SecretId: secretName }).promise();

        const credentials = JSON.parse(secret.SecretString);

        const auth = new google.auth.GoogleAuth({
            credentials,
            scopes: ['https://www.googleapis.com/auth/spreadsheets.readonly'],
        });

        const authClient = await auth.getClient();

        const response = await sheets.spreadsheets.values.get({
            auth: authClient,
            spreadsheetId: spreadsheetId,
            range: range,
        });

        const rows = response.data.values;
        return {
            statusCode: 200,
            body: JSON.stringify(rows),
        };
    } catch (error) {
        return {
            statusCode: 500,
            body: JSON.stringify({ error: error.message }),
        };
    }
};