---
layout: post
title: Blogging Like a Hacker
---

class: center, middle

# Cryptography and Security

## How to keep your data safe (a bit)

### Chris Wilson, [Aptivate](http://www.aptivate.org/), AfNOG 2014

---

## Credits

Based on presentations by:

* [Marcus Adomey](http://www.afnog.org/afnog_chix2011/Thursday/MA/CryptographySlides.odp) (AfChix, Malawi, 2011)
* [NSRC](https://nsrc.org/workshops/2013/nsrc-tenet-tut/raw-attachment/wiki/AgendaTrack2) (NSRC-TENET Workshop, South Africa, 2013)

You can access this presentation at: http://afnog.github.io/sse/crypto/presentation

Download or edit this presentation [on GitHub](https://github.com/afnog/sse/crypto/presentation.md).

---

## What we can talk about

* What is security?
* How secure are you?
* Attack vectors
* 

---

## What do you care about?

What is security?

--

* Trying to prevent some particular event.

What do you want to prevent? What is the **threat**?

--

* Is your data valuable to someone else?
* Are your systems valuable to someone else?
* Can someone cause expensive damage (e.g. death)?
* What prevents them from doing that?

???

* Is your data valuable to someone else?
  * Sell it?
  * Blackmail?
  * Steal money or resources?
  * Embarrass somebody important?
  * Threaten to or actually cause downtime?
* Are your systems valuable to someone else?
  * CPU time?
  * Disk space?
  * Network bandwidth?
  * IP addresses?
  * Access to other systems?
* What prevents them from doing that? - brainstorm

---

## Examples of security measures

Make a list of measures that you actually use.

--

For example:

* Locks on doors
* Security lights
* Video cameras
* Passwords
* Dual signatures
* Thumb prints
* Credit card PIN
* Credit limits

---

## How secure are you?

How would you crack the defensive measures that we just listed?

---

## Absolute security

> The only truly secure system is one that is powered off, cast in a block of concrete and sealed in a lead-lined room with armed guards - and even then I have my doubts. - [Gene Spafford](http://spaf.cerias.purdue.edu/quotes.html)

Security is **impossible** if:

* some users have additional rights (privileges)
* AND you cannot distinguish users using only laws of physics
* OR you cannot make it physically impossible to violate policy

---

## Living with insecurity

* **Can't** be completely secure
* **Can** make individual attacks:
  * More expensive
  * More risky
  * Less rewarding
* Beware the side effects (systems harder to use)
* Increase transparency
  * more eyes on attackers
  * more understanding of what security means

---

## Reducing specific risks

* Use encrypted communications
* Use multi-factor authentication
* Verify authenticity of messages
* Reduce risks (don't keep sensitive data)
* Increase risks for attackers (monitoring and logging)

---

## Goals of system security

Why do you lock your doors?

* Confidentiality
* Integrity
* Authentication
  * Access Control
  * Verification
  * Non-repudiation
* Availability

---

### Confidentiality (secrecy)

--

* Ensuring that no one can read the message except the intended receiver.
* Data is kept secret from those without the proper credentials, even if that data travels through an insecure medium.
* How does this prevent 

---

### Integrity (anti-tampering)

--

* Assuring the receiver that the received message has not been altered in any way from the original.
* Preventing unauthorised or undetected changes to the protected system.

---

### Authentication

--

* The process of proving one's identity.
  * The primary forms of host-to-host authentication on the Internet today are name-based or address-based, both of which are notoriously weak.
* Cryptography can help establish identity for authentication purposes (how?)

--

  * Can prove that you possess a secret
  * Or that you spent a LOT of energy to brute-force it

---

### Non-repudiation

--

* A mechanism to prove that the sender really sent this message

---

## How do we use cryptography?

* ssh/scp/sftp
* SSL/TLS/https
* pops/imaps/smtps
* VPNs
* dnssec
* wep/wpa
* digital signatures (software)
* certificates and pki
* DRM
* disk encryption

---

## Applied Cryptography

<img src="https://www.schneier.com/images/cover-applied-200h.gif">
<img src="https://www.schneier.com/images/bruce-blog3.jpg">

Written by Bruce Schneier. Perhaps the best book around if you
want to understand how cryptography works.

https://www.schneier.com/book-applied.html

---

class: small

## Cryptographic Tools

* hashes/message digests
  * MD5, SHA1, SHA256, SHA512
  * collisions
* entropy (randomness)
* keys
  * symmetric/asymmetric (public/private)
  * length
  * creation
  * distribution
* ciphers
  * block/stream
  * AES, 3DES, Blowfish, IDEA
* plaintext/ciphertext
* password/passphrase

---

## Ciphers &rarr; ciphertext

The foundation of all of cryptography:

* We start with *plaintext*. Something you can read.
* We apply a mathematical algorithm (*cipher*) to it.
* The plaintext is turned in to *ciphertext*.
* Almost all ciphers were secret until recently.
* Creating a secure cipher is HARD.

---

## FIN

Any questions?
