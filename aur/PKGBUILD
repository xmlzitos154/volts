pkgname=volts
pkgver=0.1.2
pkgrel=1
pkgdesc="A Simple script for show battery status and info"
arch=('any')
url="https://github.com/xmlzitos154/volts"
license=('Unlicense')
depends=('bash')

source=("git+$url.git")
sha256sums=('SKIP')

package() {
    cd "$srcdir/volts"
    install -Dm755 main.sh "$pkgdir/usr/bin/volts"
    install -Dm644 README.md "$pkgdir/usr/share/doc/volts/README.md"
}
