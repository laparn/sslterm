# sslterm
A secured web terminal to access computers

## Introduction

I have written for Augeo Group and its Planzone software a command line interface tool. Planzone 7 is a collaborative web project management software. I basically used the cli to do administrative staff (create users, ...). I find it soooooooo practical to have something where I can write scripts and get the result. I use it daily for administration, for imports, for exports, debug, configuration, test, ... Well all kind of work.

But at the same time, I was sometime frustrated. For example, when you get a list of something, you would like to have the possible actions associated. Some kind of buttons. I looked at what was possible, and found no nice solution in the terminal. So I decided to do something weird. I created an express node server, and created a very simple web interface. Well, a terminal in the web browser.

And really it is __cool__. It is not perfect. For example, it took me a while for integrating socket.io, and have real time display of what is going on. I like it because, I have a fairly poor memory and fight remembering the tons of options of each command I created. Here, I can very easily add a button and get the action. When I click on the button, the command is send to the command line and executed. So I can at the same time, learn and modify the command line if required.

I have totally stopped using the "basic" command line tool from the terminal and use only this intermediate version, half cli, half web.

Doing that, it occured to me that for "normal" terminal (with linux, I only use linux for about 30 years now), it would be very practical. I could easily have all normal commands running "normally" (I type, I get the output), but add some cosy functions with buttons for speedy actions. Moreover, if it is web, it means that it can be used remotely, and that interests me very much.

So my idea is to create a web terminal ultra secured that could replace ssh connection. To achieve that, I will take advantage of rarely used possibilities of ssl/tls. At the same time, integrate some specific commands to navigate, and edit files. And offer the possibility to record all actions in a remote server.

Ah, and I will use Mistral AI Codestral to help me program that (thanks to continue in VS Code). Because, the general conditions of Mistral AI says that whatever is generated belongs to me. Thanks to them !

## Security

The connection to the server will at least asks for a client certificate. So a common CA will be used tosign all certificates. To achieve that, Mistral AI advices the following steps :

### Adding certificate authentication to client and server

1. **Generate Server and CA Certificates**:
   - Generate a private key for the Certificate Authority (CA).
   - Generate a self-signed certificate for the Certificate Authority (CA).
   - Generate a private key for the server.
   - Generate a Certificate Signing Request (CSR) for the server.
   - Generate a certificate signed by the Certificate Authority (CA) for the server.

2. **Generate Client Certificates for Each User**:
   - Generate a private key for each user.
   - Generate a Certificate Signing Request (CSR) for each user.
   - Generate a certificate signed by the Certificate Authority (CA) for each user.
   - Import the certificate in your web browser

You will find all the steps till there with openssl in the file gen-key.sh

3. **Configure the Server to Verify Client Certificates**:
   - Configure the Express server to request and verify client certificates.
   - Normalize the certificates for correct comparison.
   - Compare the client certificates with the authorized certificates.

Which translates into the following instructions with openssl.

### Step 1: Generate Server Certificates

#### 1. Generate a Private Key for the Certificate Authority (CA)
```bash
openssl genpkey -algorithm RSA -out ca-key.pem
```

#### 2. Generate a Self-Signed Certificate for the Certificate Authority (CA)
```bash
openssl req -new -x509 -key ca-key.pem -out ca-cert.pem -days 365
```

#### 3. Generate a Private Key for the Server
```bash
openssl genpkey -algorithm RSA -out server-key.pem
```

#### 4. Generate a Certificate Signing Request (CSR) for the Server
```bash
openssl req -new -key server-key.pem -out server-csr.pem
```

#### 5. Generate a Certificate Signed by the Certificate Authority (CA) for the Server
```bash
openssl x509 -req -in server-csr.pem -CA ca-cert.pem -CAkey ca-key.pem -CAcreateserial -out server-cert.pem -days 365
```

### Step 2: Generate Client Certificates for Each User

For each user, generate a private key and a Certificate Signing Request (CSR), then generate a certificate signed by the Certificate Authority (CA).

#### 1. Generate a Private Key for the User
```bash
openssl genpkey -algorithm RSA -out user1-key.pem
```

#### 2. Generate a Certificate Signing Request (CSR) for the User
```bash
openssl req -new -key user1-key.pem -out user1-csr.pem
```

#### 3. Generate a Certificate Signed by the Certificate Authority (CA) for the User
```bash
openssl x509 -req -in user1-csr.pem -CA ca-cert.pem -CAkey ca-key.pem -CAcreateserial -out user1-cert.pem -days 365
```

When importing the certificate in chromium, I needed a pkcs#12 file.

To import a client certificate into Chromium (or any other Chromium-based browser like Google Chrome), you must use a file in the PKCS#12 (.p12 or .pfx) format. This format includes both the certificate and the private key, which is necessary for mutual authentication (mTLS).

Here's how you can create a PKCS#12 file for each user and import it into Chromium:

### 4. Generate a PKCS#12 File for Each User

Use OpenSSL to create a PKCS#12 file that contains both the certificate and the private key of the user.

```bash
openssl pkcs12 -export -out user1.p12 -inkey user1-key.pem -in user1-cert.pem
```

You will be prompted to enter a password to protect the PKCS#12 file. Note this password, as you will need it to import the certificate into the browser.

### 5: Import the PKCS#12 File into Chromium

1. **Open Chromium and go to Settings:**
   - Click on the three vertical dots in the top-right corner to open the menu.
   - Select "Settings".

2. **Access Certificates:**
   - In the "Privacy and security" section, click on "Certificates".
   - Go to the "Personal" tab (or "Authorities").

3. **Import the Certificate:**
   - Click on "Import".
   - Select the `user1.p12` file that you generated.
   - Enter the password you set when creating the PKCS#12 file.
   - Follow the instructions to import the certificate.

### Security next step

For the time being, I will consider that as enough. However, I think that either totp or PAM authentication should be added.

## Functionalities

### Terminal


### Basic execution of instructions


### The problem of color for terminal
