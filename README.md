# GuardBear

GuardBear helps with browser restrictions while still offering privacy & security protection to the end user.

# Introduction

If you manage a website or are a web based vendor, then you have struggled with the privacy restrictions imposed by the browsers (ITP / Safari, ETP / FireFox, Chrome dropping 3rd party cookies, etc). CNAME Cloaking is becoming a popular work around to try. According to the academic paper called "[The CNAME of the Game:Large-scale Analysis of DNS-based TrackingEvasion](https://arxiv.org/abs/2102.09301)", CNAME Cloaking has the following potential risks:

* Transport Security (6.1)
* Session Fixation (6.2.1)
* Cross-Site Scripting (6.2.2)
* Information Leakage (6.3)
* Cookie Leaks (6.4)

In the Discussion (7), the authors introduce the idea of using a reverse proxy instead of CNAME Cloaking. GuardBear is a reverse proxy to help with browser restrictions while addressing the security & privacy concerns.

# How it Works

GuardBear is a reverse proxy which will take traffic destined for a 3rd party and do the following:

* Only send cookies meant for that 3rd party
* Mask identifying information - Currently, client ip address and referring url

![GuardBear Traffic Flow](https://github.com/silevitch/GuardBear/blob/main/GuardBear.png)

You will create a CNAME that is named *3rdparty.guardbear.example.com* that points to a GuardBear proxy that will forward traffic to *3rdparty.com*. On *example.com*, you will change the references to *3rdparty.com* to *3rdparty.guardbear.example.com*.

When GuardBear sees a cookie being set from *3rdparty.com*, it will change it's domain to *3rdparty.guardbear.example.com* along with making a second cookie that is prefixed with "guardbear_". These new cookies tell GuardBear which cookies belong to the 3rd party. 

# Try it Out

To try out the POC in the repository, you will first need to install:

* Docker
* Docker-Compose

Then running "sudo docker-compose up" will install a GuardBear container along with an example 3rd party origin container. Both are based on openresty.

To run the test suite, you will need to install:

* Perl
* Test::WWW::Mechanize perl package (using cpan)

```
$ perl t/01.base_cases.pl 
1..16
# Make a request with a cookie that is not flagged to be sent to the origin and make sure it is not sent
ok 1 - GET http://localhost:8080/echo_headers
ok 2 - Content lacks "Cookie: foobar=1"
# Make a request with a cookie that is flagged to be sent to the origin and make sure it is sent
ok 3 - GET http://localhost:8080/echo_headers
ok 4 - Content contains "Cookie: foobar=1"
ok 5 - GET http://localhost:8080/echo_headers
ok 6 - Cookie Test1 get domain rewritten
ok 7 - Cookie flag guardbear_Test1 is set
ok 8 - Cookie Test2 get domain rewritten
ok 9 - Cookie flag guardbear_Test2 is set
# This will make sure that we are masking client IPs sent in X-Forwarded-For header sent to the origin
ok 10 - GET http://localhost:8080/echo_headers
ok 11 - Content contains "X-Forwarded-For: 0.0."
# Let us pass in a XFF
ok 12 - GET http://localhost:8080/echo_headers
ok 13 - Content contains "X-Forwarded-For: 1.2.2.2, 0.0."
# This will make sure that we are scrubbing Referer headers that are sent to the origin
ok 14 - GET http://localhost:8080/echo_headers
ok 15 - Content contains "Referer: https://www.google.com/"
ok 16 - Content lacks "Referer: https://www.google.com/a/b/c/d"
```

# How can I help?

* Try it out!
* Star the project!
* Leave feature requests or file bugs!

# What's next?

- [ ] Multi-domain support
- [ ] Script that will build proxy_default.conf based on variables
- [ ] Let's Encrypt support
- [ ] End point to extend javascript created cookies
- [ ] K8s support
- [ ] ipv6 support for anonymizing ip
- [ ] Anonymize user-agents

# References

1. https://arxiv.org/abs/2102.09301
