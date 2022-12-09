$ kubectl logs vault-0

WARNING! Unable to read storage migration status.
2022-12-08T06:37:39.491Z [INFO]  proxy environment: http_proxy="" https_proxy="" no_proxy=""
2022-12-08T06:37:39.491Z [WARN]  storage.consul: appending trailing forward slash to path
2022-12-08T06:37:39.492Z [WARN]  storage migration check error: error="Unexpected response code: 500 (No known Consul servers)"
2022-12-08T06:37:41.493Z [WARN]  storage migration check error: error="Unexpected response code: 500 (No known Consul servers)"
2022-12-08T06:37:50.566Z [WARN]  storage migration check error: error="Unexpected response code: 500 (rpc error making call: No cluster leader)"
2022-12-08T06:37:59.839Z [WARN]  storage migration check error: error="Unexpected response code: 500 (rpc error making call: No cluster leader)"
2022-12-08T06:38:04.573Z [INFO]  core: Initializing version history cache for core
==> Vault server configuration:

             Api Address: http://10.244.2.4:8200
                     Cgo: disabled
         Cluster Address: https://vault-0.vault-internal:8201
              Go Version: go1.19.2
              Listener 1: tcp (addr: "[::]:8200", cluster address: "[::]:8201", max_request_duration: "1m30s", max_request_size: "33554432", tls: "disabled")
               Log Level: info
                   Mlock: supported: true, enabled: false
           Recovery Mode: false
                 Storage: consul (HA available)
                 Version: Vault v1.12.1, built 2022-10-27T12:32:05Z
             Version Sha: e34f8a14fb7a88af4640b09f3ddbb5646b946d9c

==> Vault server started! Log data will stream in below:

2022-12-08T06:38:07.374Z [INFO]  core: security barrier not initialized
2022-12-08T06:38:07.375Z [INFO]  core: seal configuration missing, not initialized



Unseal Key 1: anzvz+2+YnWj+0ffNdnHeAjLXOw7grvg0RtN2PG1A+o=
Initial Root Token: hvs.OyLI3Tm1wikO5bzwIQqrM2fu


$ kubectl exec -it vault-0 -- vault status
Key             Value
---             -----
Seal Type       shamir
Initialized     true
Sealed          false
Total Shares    1
Threshold       1
Version         1.12.1
Build Date      2022-10-27T12:32:05Z
Storage Type    consul
Cluster Name    vault-cluster-f9e3dfe5
Cluster ID      9e5b07c6-4df6-2dac-75a2-8088a577f494
HA Enabled      true
HA Cluster      https://vault-0.vault-internal:8201
HA Mode         active
Active Since    2022-12-08T07:01:37.9132327Z


$ kubectl exec -it vault-0 -- vault login
Token (will be hidden):
Success! You are now authenticated. The token information displayed below
is already stored in the token helper. You do NOT need to run "vault login"
again. Future Vault requests will automatically use this token.

Key                  Value
---                  -----
token                hvs.OyLI3Tm1wikO5bzwIQqrM2fu
token_accessor       lka29EqLZa7tiXQRqGn1vHbR
token_duration       ∞
token_renewable      false
token_policies       ["root"]
identity_policies    []
policies             ["root"]


$ kubectl exec -it vault-0 -- vault auth list
Path      Type     Accessor               Description                Version
----      ----     --------               -----------                -------
token/    token    auth_token_2b81b38a    token based credentials    n/a


$ kubectl exec -it vault-0 -- vault kv get otus/otus-rw/config
====== Data ======
Key         Value
---         -----
password    asajkjkahs
username    otus

$ kubectl exec -it vault-0 -- vault read otus/otus-ro/config
Key                 Value
---                 -----
refresh_interval    768h
password            asajkjkahs
username            otus


$ kubectl exec -it vault-0 -- vault auth list
Path           Type          Accessor                    Description                Version
----           ----          --------                    -----------                -------
kubernetes/    kubernetes    auth_kubernetes_94037ed3    n/a                        n/a
token/         token         auth_token_2b81b38a         token based credentials    n/a


root@vault-agent-example:/# curl localhost
<html>
<body>
<p>Some secrets:</p>
<ul>
<li><pre>username: otus</pre></li>
<li><pre>password: asajkjkahs</pre></li>
</ul>

</body>
</html>



kubectl exec -it vault-0 -- vault write pki_int/issue/example-dot-ru common_name="test.example.ru" ttl="24h"
Key                 Value
---                 -----
ca_chain            [-----BEGIN CERTIFICATE-----
MIIDnTCCAoWgAwIBAgIUMRvpzi6xlj+djLIttzrIvO/bSPMwDQYJKoZIhvcNAQEL
BQAwFjEUMBIGA1UEAxMLZXhhbWFwbGUucnUwHhcNMjIxMjA5MDMyODI5WhcNMjcx
MjA4MDMyODU5WjAsMSowKAYDVQQDEyFleGFtcGxlLnJ1IEludGVybWVkaWF0ZSBB
dXRob3JpdHkwggEiMA0GCSqGSIb3DQEBAQUAA4IBDwAwggEKAoIBAQDR+C6r/1gO
WRr2DZMVj29ZkLBSttcBNlNccqinVAYc2vJTYRKJwwvg/fTVmp3zGXlJErvCTSWv
9yZnhHbR7nZjCd1ThyW8ZZzE9kIPaH0VAKBBz6r3WRHiSnfx+vXcGYkdsW0Sgn0j
lI7co6U2IlUl/PuxPoDEQjJbYLRfyu6mK7NbaPzsm2hWY7mNYjnYrkFFZSVxfemu
RIanSCbVJJ40lMmvYTP3cxF8WNftGp4zqmhT+W4nw53b7PYLVW+fq7JM9byLJgyo
n43BsOsaOw+sTuHqCpyttJytQZEZC9N491gIR9WwJpPSsag0NkF0RjbnaiEmHzd9
1YOGsTMvwsm3AgMBAAGjgcwwgckwDgYDVR0PAQH/BAQDAgEGMA8GA1UdEwEB/wQF
MAMBAf8wHQYDVR0OBBYEFFJ202Ry3bZPYj0B7yvxEegGb3uQMB8GA1UdIwQYMBaA
FHwxalG4U8HlNKk1nBjZg3gF7KPpMDcGCCsGAQUFBwEBBCswKTAnBggrBgEFBQcw
AoYbaHR0cDovL3ZhdWx0OjgyMDAvdjEvcGtpL2NhMC0GA1UdHwQmMCQwIqAgoB6G
HGh0dHA6Ly92YXVsdDo4MjAwL3YxL3BraS9jcmwwDQYJKoZIhvcNAQELBQADggEB
AFor0l0qYy6GM3uGqXeobbwrqPn5VCDOshmCox3W9qdU3+lY362fSHLPTraWo4fz
uKkXbaj1wWpQRgcFroSvGpbt+URrtH00EpVcEoH8pDmj14pjAjYuDAaOXxGvhBUi
AMe5K/mL1KOSSKYh/xZnHMu6WS4imXSCQSHO/WsuZuvrD7dmhF6ngpJcpU02KmvO
lg2dA//KibGx84TLOOfwZhEADw6zV7LR9D0sDM8CuO+gXFaBp5ZhoXyMwMe9Hnxx
EHfg9EFB2IRhHprBeMu99ZdU5AioWjwwFc73Oja3uv2YynCXTpzdfW0zB5F1WUlA
tANbn5DiXIG+0CTaFth8d24=
-----END CERTIFICATE----- -----BEGIN CERTIFICATE-----
MIIDNTCCAh2gAwIBAgIUXyDRpRnh6q6WWQDCwcezrQZIJ4QwDQYJKoZIhvcNAQEL
BQAwFjEUMBIGA1UEAxMLZXhhbWFwbGUucnUwHhcNMjIxMjA5MDMyMTA4WhcNMzIx
MjA2MDMyMTM4WjAWMRQwEgYDVQQDEwtleGFtYXBsZS5ydTCCASIwDQYJKoZIhvcN
AQEBBQADggEPADCCAQoCggEBANjUgyM/05YKv8RYp03V82iZlaA+bBGlvxjE8VKt
NGNOW71kV2qb2HBbqw97J+kGSzm6wo6Z+6wNg03DCTnMiy2z/MPmn/riKL0hqiO3
792Tu0OEY8De0YBrSqJJi6xfLsMWmPpW3kTYfX6fHVfrJuD3LEjkX0uzoFoHpy7U
L/9j8b3UVyHJWVwt7BdIkpdWlEGLroxsR4Lua8MceqqMgIqIThk6Rl/QRAUYY6yH
9fgnKdtY+eZZZ+wJDpYvHbKPRLlN7yepDKPH3VIxvSrsv5s24Sr/HGSBKm+ypjbe
ipioLgRzxW3F4p5/2FjwRDyO6653BIaESppa1Ulvnrckw/UCAwEAAaN7MHkwDgYD
VR0PAQH/BAQDAgEGMA8GA1UdEwEB/wQFMAMBAf8wHQYDVR0OBBYEFHwxalG4U8Hl
NKk1nBjZg3gF7KPpMB8GA1UdIwQYMBaAFHwxalG4U8HlNKk1nBjZg3gF7KPpMBYG
A1UdEQQPMA2CC2V4YW1hcGxlLnJ1MA0GCSqGSIb3DQEBCwUAA4IBAQDMP1exDBGs
ZdsvBjzlYC+TvUCVas2bKglfQGcFCOXZrMkahuh8tgZoHRDRZbj81/hwcdTFPYHF
zn8yqcZ6/0fSap/srr5h0ajoWwoLeuLGmWDWb6h3Q214n09qlrw9aUuTZI/PyfsG
LUyhAthihfKfzjFWA4JH6STNB8hOUApnagw5k1yto/jobKjNMj99rRRR1L56xeYZ
YHwsYHILnTztG1vnVxZKLnEYrHw4xo1zanWtDDlVAE7ntyqfg7TZNfHcvHm1aAAc
xJ8A5a4YmQYTthF8K6gVOB7cPR87mmsPy8ESZ0sEnjlyoiHuObtzb+EO3OFecalb
nGrU05EWObDj
-----END CERTIFICATE-----]
certificate         -----BEGIN CERTIFICATE-----
MIIDYzCCAkugAwIBAgIUZvtd9vYSL5WW3of2fmLnOYX8G9MwDQYJKoZIhvcNAQEL
BQAwLDEqMCgGA1UEAxMhZXhhbXBsZS5ydSBJbnRlcm1lZGlhdGUgQXV0aG9yaXR5
MB4XDTIyMTIwOTAzNDAzM1oXDTIyMTIxMDAzNDEwM1owGjEYMBYGA1UEAxMPdGVz
dC5leGFtcGxlLnJ1MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEA5+D5
uA0yUwETIpIO1dLxtnnVkfMPmIF2uXQ/VLV1SGlIr7X1IPgPOl64y3dEVkk0QytL
dyd4SZAgGDNkfdu5s3caEuHCkHULw0xn0t/Z3dofmYFMpBxR5KDYnrFv7tCI9ARw
SmJMFkI2KZUy6px29xzNiIDDtVMjYM+rOc9oOoiCMZArGbxFXa69M91SLUl9Mwhf
9qW/Lj5rqr2KNRr/8cwzD+wBlZg2BwdLwazr8TOUvd0dfj3ODyhw2GhQW8Kb8aLc
QTQ4+7TGzy0eBPI04shkt4k+NbZ/lL08xHLSrLoX6w1ER0lEGXkzq5VgYKvatWZ2
QcBs1jXLwoHe60ohWwIDAQABo4GOMIGLMA4GA1UdDwEB/wQEAwIDqDAdBgNVHSUE
FjAUBggrBgEFBQcDAQYIKwYBBQUHAwIwHQYDVR0OBBYEFPkRFiqVBTUcwlZQyhoK
qEM/tYADMB8GA1UdIwQYMBaAFFJ202Ry3bZPYj0B7yvxEegGb3uQMBoGA1UdEQQT
MBGCD3Rlc3QuZXhhbXBsZS5ydTANBgkqhkiG9w0BAQsFAAOCAQEAtLMyZfrMIoEC
YB43nM/wv6dAdKiVOS2gtQfjLATLXukjbcl1A6Wak8ZhODRzVp7hwBdOmN4jgw+g
cWUYOngJ1KTmhmosAfWaxeJSjgOCJ7QMmHHwyre2VS3H3s8ljd9l4ioJp+4sdb7n
c+aHK33hoCNG51eSDx0R8NQ2woAohVjNYYVGh8yFIlJK3nkKYfif1LZLSBWgOMPn
obM9TstZWcmPgGPairv6NT6gBY3QneSv/4Wo6nPVA/K92v+fObs9GxwAVDmdzv1/
DVF3bwLMTwcfxADb5YKfeHir8ah6akSWTnJrPfWH6Gs8XnzrH87ANvrw5W8X3zQT
W1Mab3md8g==
-----END CERTIFICATE-----
expiration          1670643663
issuing_ca          -----BEGIN CERTIFICATE-----
MIIDnTCCAoWgAwIBAgIUMRvpzi6xlj+djLIttzrIvO/bSPMwDQYJKoZIhvcNAQEL
BQAwFjEUMBIGA1UEAxMLZXhhbWFwbGUucnUwHhcNMjIxMjA5MDMyODI5WhcNMjcx
MjA4MDMyODU5WjAsMSowKAYDVQQDEyFleGFtcGxlLnJ1IEludGVybWVkaWF0ZSBB
dXRob3JpdHkwggEiMA0GCSqGSIb3DQEBAQUAA4IBDwAwggEKAoIBAQDR+C6r/1gO
WRr2DZMVj29ZkLBSttcBNlNccqinVAYc2vJTYRKJwwvg/fTVmp3zGXlJErvCTSWv
9yZnhHbR7nZjCd1ThyW8ZZzE9kIPaH0VAKBBz6r3WRHiSnfx+vXcGYkdsW0Sgn0j
lI7co6U2IlUl/PuxPoDEQjJbYLRfyu6mK7NbaPzsm2hWY7mNYjnYrkFFZSVxfemu
RIanSCbVJJ40lMmvYTP3cxF8WNftGp4zqmhT+W4nw53b7PYLVW+fq7JM9byLJgyo
n43BsOsaOw+sTuHqCpyttJytQZEZC9N491gIR9WwJpPSsag0NkF0RjbnaiEmHzd9
1YOGsTMvwsm3AgMBAAGjgcwwgckwDgYDVR0PAQH/BAQDAgEGMA8GA1UdEwEB/wQF
MAMBAf8wHQYDVR0OBBYEFFJ202Ry3bZPYj0B7yvxEegGb3uQMB8GA1UdIwQYMBaA
FHwxalG4U8HlNKk1nBjZg3gF7KPpMDcGCCsGAQUFBwEBBCswKTAnBggrBgEFBQcw
AoYbaHR0cDovL3ZhdWx0OjgyMDAvdjEvcGtpL2NhMC0GA1UdHwQmMCQwIqAgoB6G
HGh0dHA6Ly92YXVsdDo4MjAwL3YxL3BraS9jcmwwDQYJKoZIhvcNAQELBQADggEB
AFor0l0qYy6GM3uGqXeobbwrqPn5VCDOshmCox3W9qdU3+lY362fSHLPTraWo4fz
uKkXbaj1wWpQRgcFroSvGpbt+URrtH00EpVcEoH8pDmj14pjAjYuDAaOXxGvhBUi
AMe5K/mL1KOSSKYh/xZnHMu6WS4imXSCQSHO/WsuZuvrD7dmhF6ngpJcpU02KmvO
lg2dA//KibGx84TLOOfwZhEADw6zV7LR9D0sDM8CuO+gXFaBp5ZhoXyMwMe9Hnxx
EHfg9EFB2IRhHprBeMu99ZdU5AioWjwwFc73Oja3uv2YynCXTpzdfW0zB5F1WUlA
tANbn5DiXIG+0CTaFth8d24=
-----END CERTIFICATE-----
private_key         -----BEGIN RSA PRIVATE KEY-----
MIIEpQIBAAKCAQEA5+D5uA0yUwETIpIO1dLxtnnVkfMPmIF2uXQ/VLV1SGlIr7X1
IPgPOl64y3dEVkk0QytLdyd4SZAgGDNkfdu5s3caEuHCkHULw0xn0t/Z3dofmYFM
pBxR5KDYnrFv7tCI9ARwSmJMFkI2KZUy6px29xzNiIDDtVMjYM+rOc9oOoiCMZAr
GbxFXa69M91SLUl9Mwhf9qW/Lj5rqr2KNRr/8cwzD+wBlZg2BwdLwazr8TOUvd0d
fj3ODyhw2GhQW8Kb8aLcQTQ4+7TGzy0eBPI04shkt4k+NbZ/lL08xHLSrLoX6w1E
R0lEGXkzq5VgYKvatWZ2QcBs1jXLwoHe60ohWwIDAQABAoIBACwDsGMXXi4TTiaJ
wvcji24vwjJqCNPR/09EmaDisNiF454208jmTT2vLTSx9u7KBnmZhkGf5F1SVkVB
vBmH08AVI4XiBKSXExyHLE4C38AU31qsCHg+R+01+uhklfKm8tge35G/BuJSvyU1
hOyztoFBnmICzyNkHJsL0Fyw2gAB/OaVRjh8MVPNHHca5WtNp4ND6ee7VlOCYzkI
CUTkcvVHL4iaa3lFY78yhldcVbt1AgmjhEm5wZ6mgsMQSFsiGoAbpjieNNq9M4PZ
hhXUJkyBzK6qgWcDpnx8RxHLFYIenAt8drCTySSNFzLGxXF73tihKqkiMdnVTbVQ
GwJMcgECgYEA6xP+W90+TWBYbjNCO439GJckmJcoGgyboedGQIEwu4u8gRMX9ibR
FksnH6zuUGH8i1qENQ3d7XRP6yyBrWEr9CyQYPYp9mi2EPi8yXL396LkxNPf5pix
oKL6AJZcuY4WRqPLSpQFLarxB3Or1plL7eXEfRIOSv+OnEjkF4N/FLsCgYEA/IQW
5YHqll0vHwIZwrKpWeOZGEvKu2FVRf0vIezskziUScfxGa36YqTc7iQqK8egc5o4
MHBqLiMoLJL6prHvmrfwmifh+kg15bkyD3BY0RLxbdUGr6jEt24qjLlRtWlMG3vD
qMNZSh5kszfKFtyVwJj5p1FYWOgfC7JLSuVAq+ECgYEArRwjEnkhOQ+67yP2IS8V
c3dR7sBZOp2QOjC6jiPUxDdJ0G9EFPNOw7ECFZReRnlx5Rj6BKu6gvNFKvSyZgAJ
wxzSEWUVT6yabnMNaver3QNqnfs8hW5qV9XMboRLsiUNCGXz/W51RcT9C7TFlRl8
TasG/+c8+UOqPDJ9LUebXKMCgYEAqawHxocZHZfXhbpfnNd3u5KW2CB1RJsONUz+
UolkHTgzS7AxbNPeHlIwsUNTor8sLQE/KC0g64dsAydvjHqbSRa3cJ3D1eyXapiZ
7o3K4BEecHJnX7jDFY3MwWn0YTUzknQC8G7ynD734wRloh7t8M/ZUHf0KSkvUyim
Ntj8L4ECgYEAmCZugqDEvOhCtx8FADeKdZ5etIfflT342sItN5kFSSynQPC9YBv9
NAJew5g641zRW9KeruIC2bqc/4Yqp2Bilr0grSEL8CLkbROzczfQxhzP5nVvQyXz
O0LoebN6W7TF+pv/xYHqof63L9zB94jtSpnqnNBoSWhsBCvJbM2dvHQ=
-----END RSA PRIVATE KEY-----
private_key_type    rsa
serial_number       66:fb:5d:f6:f6:12:2f:95:96:de:87:f6:7e:62:e7:39:85:fc:1b:d3

