# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7..9} )
PYTHON_REQ_USE="threads(+)"
DISTUTILS_USE_SETUPTOOLS=rdepend

inherit distutils-r1

DESCRIPTION="Python code static checker"
HOMEPAGE="https://www.logilab.org/project/pylint
	https://pypi.org/project/pylint/
	https://github.com/pycqa/pylint/"
SRC_URI="
	https://github.com/pycqa/pylint/archive/${P}.tar.gz"
S=${WORKDIR}/${PN}-${P}

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~ia64 ~ppc ~ppc64 ~sparc ~x86"
IUSE="examples"

RDEPEND="
	<dev-python/astroid-2.7[${PYTHON_USEDEP}]
	>=dev-python/astroid-2.5.2[${PYTHON_USEDEP}]
	>=dev-python/isort-4.2.5[${PYTHON_USEDEP}]
	<dev-python/isort-6[${PYTHON_USEDEP}]
	>=dev-python/mccabe-0.6[${PYTHON_USEDEP}]
	<dev-python/mccabe-0.7[${PYTHON_USEDEP}]
	>=dev-python/toml-0.7.1[${PYTHON_USEDEP}]
"

PATCHES=(
	"${FILESDIR}/${PN}-2.4.4-sphinx-theme.patch"
)

distutils_enable_sphinx doc --no-autodoc
distutils_enable_tests pytest

python_test() {
	local skipped_tests=(
		# No need to run the benchmarks
		tests/benchmark/test_baseline_benchmarks.py
		# Fails when graphviz is installed (?!)
		tests/test_import_graph.py::test_missing_graphviz
		# TODO
		'tests/lint/unittest_expand_modules.py::test_expand_modules[files_or_modules1-expected1]'
	)
	[[ ${EPYTHON} == python3.8 ]] && skipped_tests+=(
		# TODO
		'tests/test_functional.py::test_functional[typing_deprecated_alias]'
		'tests/test_functional.py::test_functional[typing_consider_using_alias]'
		'tests/test_functional.py::test_functional[typing_consider_using_alias_without_future]'
	)
	# Specify the test directory explicitly to avoid import file mismatches
	epytest tests ${skipped_tests[@]/#/--deselect }
}

python_install_all() {
	if use examples ; then
		docompress -x "/usr/share/doc/${PF}/examples"
		docinto examples
		dodoc -r examples/.
	fi

	distutils-r1_python_install_all
}
