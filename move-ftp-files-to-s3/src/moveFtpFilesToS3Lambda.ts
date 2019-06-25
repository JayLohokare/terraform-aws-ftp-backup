import ProcessEnv = NodeJS.ProcessEnv;
import { FtpClient } from './ftp/ftpClient';
import { S3Storage } from './s3/s3Storage';
import { SsmClient } from './ssm/ssmClient';
import { ImportFilesEvent } from './importFilesEvent';

class MoveFtpFilesToS3Lambda {

    private readonly ftpConfigParameter: string;

    constructor(env: ProcessEnv, public ssm: SsmClient, public ftp: FtpClient, public s3: S3Storage) {
        this.ftpConfigParameter = this.getFtpConfigParameter(env);
    }

    private getFtpConfigParameter(env: ProcessEnv): string {
        if (!env.FTP_CONFIG_PARAMETER) {
            throw new Error('env variable FTP_CONFIG_PARAMETER must be defined');
        }
        return env.FTP_CONFIG_PARAMETER;
    }

    async execute(event: ImportFilesEvent): Promise<void> {
        const ftpConfig = await this.readFtpConfiguration();
        this.ftp.configure(ftpConfig);
        await this.ftp.connect();
        const files = await this.ftp.list(event.ftp_path);
        for (const ftpFile of files) {
            const fileStream = await this.ftp.get(`${event.ftp_path}/${ftpFile.name}`);
            await this.s3.put(fileStream, ftpFile.name, event.s3_bucket);
            await this.ftp.delete(`${event.ftp_path}/${ftpFile.name}`);
        }
        this.ftp.disconnect();
    }

    private async readFtpConfiguration(): Promise<string> {
        try {
            return await this.ssm.getParameter(this.ftpConfigParameter);
        } catch (e) {
            console.log(e);
            throw Error(`AWS Parameter Store doesn't have ${this.ftpConfigParameter} parameter created`);
        }
    }
}

export { MoveFtpFilesToS3Lambda };

