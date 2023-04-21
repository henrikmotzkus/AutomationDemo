# Configuration data file (ConfigurationData.psd1).

@{
    AllNodes = 
    @(
        @{
            # NodeName "*" = apply this properties to all nodes that are members of AllNodes array.
            Nodename                    = "*"
            # Name of the remote domain. If no parent name is specified, this is the fully qualified domain name for the first domain in the forest.
            DomainName                  = "localtestdomain.local"
            # Maximum number of retries to check for the domain's existence.
            RetryCount                  = 20
            # Interval to check for the domain's existence.
            RetryIntervalSec            = 30
            # The path to the .cer file containing the public key of the Encryption Certificate used to encrypt credentials for this node.
            CertificateFile             = "user.cer"
            # The thumbprint of the Encryption Certificate used to decrypt the credentials on target node.
            Thumbprint                  = "C7268FD08F6156F923DE4B4067AEE153C59DBAC7"
        },

        @{
            Nodename = "192.168.35.5"
            Role = "DC01"
        },

        @{
            Nodename = "192.168.35.6"
            Role = "DC02"
        }
    )
}