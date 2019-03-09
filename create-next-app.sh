#!/bin/sh

set -e

if [ -e package.json ]
then
  echo "package.json exists, exiting..."
  exit 1
fi

export PROJECT_NAME=${PWD##*/}

mkdir ./pages

cat <<EOF > ./package.json
{
  "name": "${PROJECT_NAME}",
  "version": "0.0.0",
  "license": "MIT",
  "scripts": {
    "dev": "next dev",
    "build": "next build",
    "start": "next start",
    "test": "standard",
    "lint": "standard",
    "lint:watch": "nodemon --quiet --exec 'standard && echo linting: OK' --watch '**/*.js' --ignore node_modules"
  }
}
EOF

cat <<EOF > ./pages/index.js
import Link from 'next/link'
import Head from 'next/head'
export default () => (
  <>
    <Head>
      <title>home | ${PROJECT_NAME}</title>
    </Head>
    <h1>home</h1>
    <nav>
      <Link href='/'><a>home</a></Link>
      &nbsp;|&nbsp;
      <Link href='/about'><a>about</a></Link>
    </nav>
    <p>home: lorem yada yada...</p>
  </>
)
EOF

cat <<EOF > ./pages/about.js
import Link from 'next/link'
import Head from 'next/head'
export default () => (
  <>
    <Head>
      <title>about | ${PROJECT_NAME}</title>
    </Head>
    <h1>about</h1>
    <nav>
      <Link href='/'><a>home</a></Link>
      &nbsp;|&nbsp;
      <Link href='/about'><a>about</a></Link>
    </nav>
    <p>about: lorem yada yada...</p>
  </>
)
EOF

cat <<EOF > ./next.config.js
module.exports = {
  target: 'serverless'
}
EOF

cat <<EOF > ./now.json
{
  "version": 2,
  "name": "${PROJECT_NAME}",
  "public": true,
  "builds": [
    { "src": "next.config.js", "use": "@now/next" }
  ],
  "alias": "${PROJECT_NAME}.now.sh"
}
EOF

cat <<EOF > ./.gitignore
node_modules
.next
*.log
EOF

yarn add next react react-dom
yarn add --dev standard nodemon

git init
git add .
git commit --all --message "Initial app boilerplate"
