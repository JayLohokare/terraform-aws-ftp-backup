import S3 = require('aws-sdk/clients/s3');
import ReadableStream = NodeJS.ReadableStream;

class S3Storage {

    private s3: S3;

    constructor(s3: S3) {
        this.s3 = s3;
    }

    async put(object: ReadableStream, objectKey: string, bucket: string): Promise<any> {
        const putRequest = {
            Body: object,
            Bucket: bucket,
            Key: objectKey
        };

        return await this.s3.putObject(putRequest).promise();
    }

}

export { S3Storage };
