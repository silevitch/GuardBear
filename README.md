# ProxyBear.io

ProxyBear.io is a reverse proxy to help with browser restrictions while still offering privacy & security protection to the end user.

# Introduction

CNAME Cloaking is becoming a common solution to privacy restrictions imposed by the browsers (ITP / Safari, ETP / FireFox, Chrome dropping 3rd party cookies, etc). According to the academic paper called "[The CNAME of the Game:Large-scale Analysis of DNS-based TrackingEvasion](https://arxiv.org/abs/2102.09301)", CNAME Cloaking has the following potential risks:

* Transport Security (6.1)
* Session Fixation (6.2.1)
* Cross-Site Scripting (6.2.2)
* Information Leakage (6.3)
* Cookie Leaks (6.4)

In the Discussion (7), the authors introduce the idea of using a reverse proxy instead of CNAME Cloaking. ProxyBear.io is a reverse proxy to help with browser restrictions while still offering privacy & security protection to the end user.


# How it Works

# Try it Out

# How can I help?

* Try it out!
* Star the project!
* Leave feature requests or file bugs!

# What's next?

- [ ] Multi-domain support
- [ ] Script that will build proxy_default.conf based on variables
- [ ] Let's Encrypt support
- [ ] End point to extend javascript created cookies
- [ ] ipv6 support for anonymizing ip
- [ ] Anonymize user-agents

# References

1. https://arxiv.org/abs/2102.09301
