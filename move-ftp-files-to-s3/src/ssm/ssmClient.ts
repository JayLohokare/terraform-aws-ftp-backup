import SSM = require('aws-sdk/clients/ssm');
import { PSParameterValue } from 'aws-sdk/clients/ssm';

class SsmClient {

    constructor(public ssm:SSM){

    }

    async getParameter(param: string): Promise<PSParameterValue> {
        const ftpConfig = await this.ssm.getParameter({Name: param, WithDecryption: true}).promise();
        return ftpConfig.Parameter.Value;
    }
}

export { SsmClient };
