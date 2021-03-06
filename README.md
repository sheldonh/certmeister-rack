# certmeister-rack

certmeister-rack provides a [Rack](http://rack.github.io/) application to offer an HTTP service around [certmeister](https://github.com/sheldonh/certmeister), the conditional autosigning certificate authority.

An example, using redis and rack and enforcing Hetzner PTY Ltd's policy, is available in [contrib/config.ru](contrib/config.ru).

To hit the service:

```
$ curl -L \
    -d "psk=secretkey" \
    -d "csr=$(perl -MURI::Escape -e 'print uri_escape(join("", <STDIN>));' < fixtures/client.csr)" \
    http://localhost:9292/ca/certificate/axl.starjuice.net
```

## Testing

```
rake spec
```

## Releasing

If you work at Hetzner and need to release new versions of this gem, do this
(obviously only after making sure the tests run and you have no uncommitted
changes):

```
# edit lib/certmeister/rack/version.rb
bundle
git commit \
  -m "Bump version to v$(bundle exec ruby -Ilib -rcertmeister/rack -e 'puts Certmeister::Rack::VERSION')" \
  Gemfile.lock lib/certmeister/rack/version.rb
bundle exec rake release
```

