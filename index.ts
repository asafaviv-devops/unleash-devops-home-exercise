import express, { Request, Response } from 'express';
import { S3 } from '@aws-sdk/client-s3';
import { env } from "process";

const app = express();
const port =  env.PORT || 3000;

const s3 = new S3();

const bucketName = env.BUCKET_NAME

if (!bucketName) {
    throw new Error("[Error] No bucket name was given")
}

app.get('/check-file', async (req: Request, res: Response) => {
  const fileName = req.query.fileName as string;

  if (!fileName) {
    return res.status(400).send('Please provide a file name.');
  }

  const params = {
    Bucket: bucketName,
    Key: fileName,
  };

  try {
    await s3.headObject(params);
    res.status(200).send(`The file "${fileName}" exists in the bucket.`);
  } catch (error: any) {
    if (error.name === 'NotFound') {
      res.status(404).send(`The file "${fileName}" does not exist in the bucket.`);
    } else {
      console.log(`[Error]: ${error.message}`)
      res.status(500).send('An error occurred while checking the file.');
    }
  }
});

app.listen(port, () => {
  console.log(`Server is running on http://localhost:${port}`);
});
