interface FtpConfig {
    host: string;
    port: number;
    user: string;
    password: string;
    connTimeout?: number;
}

export { FtpConfig };
