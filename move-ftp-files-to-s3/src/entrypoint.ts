import { Handler } from 'aws-lambda';
import AWS from 'aws-sdk';
import { MoveFtpFilesToS3Lambda } from './moveFtpFilesToS3Lambda';
import { S3Storage } from './s3/s3Storage';
import { FtpClient } from './ftp/ftpClient';
import { SsmClient } from './ssm/ssmClient';
import { ImportFilesEvent } from './importFilesEvent';

const s3 = new AWS.S3();
const s3Storage = new S3Storage(s3);

const ssm = new AWS.SSM();
const ssmClient = new SsmClient(ssm);

const ftpClient = new FtpClient();

const handler: Handler<ImportFilesEvent, void> = async (event: ImportFilesEvent) => {
    console.log(`start execution for event ${JSON.stringify(event)}`);

    try {
        const lambda = new MoveFtpFilesToS3Lambda(process.env, ssmClient, ftpClient, s3Storage);
        await lambda.execute(event);
    } catch (e) {
        console.log(e);
        throw new Error(e);
    }
};

export { handler };
