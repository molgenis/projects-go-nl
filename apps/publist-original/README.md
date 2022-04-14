# Custom Vue Template as a molgenis app

The purpose of this molgenis app is to dynamically render publication data in the browser. There is a GitHub Action that automatically pushes new publications into the database.

## Getting Started

### 1. Install Node and NPM

Make sure [Node and NPM](https://nodejs.org/en/) are installed on your machine. You may also use [Yarn](https://yarnpkg.com/en/). To test the installation or to see if these tools are already installed on your machine, run the following commands in the terminal.

```shell
node -v
npm -v
```

### 2. Install dependencies

Make sure the current working directory is `public/publist`.

```shell
cd public/publist
```

Next, install the npm packages that are required to run the app locally. I have decided to use [pnpm](https://github.com/pnpm/pnpm) to manage packages on my machine and across projects. To install `pnpm`, run the following command.

```shell
npm install -g pnpm
```

If you prefer to use `npm`, use the following.

```shell
npm install

cd client
npm install
```

### 3. Start the Development Server

When everything is installed, navigate back to the main directory and start the development server. This will start the client at port `localhost:3000`.

```shell
npm run dev
```

### 4. Building for production

After you have made all of the changes, you will need to build the site. Run the following command.

```shell
npm run build
```

The built site will written to the `dist` folder.

### 5. Importing into Molgenis

Next, the built site needs to be written to a zipped file. I have simplified this step a bit by writing a script. Run the following command in the terminal.

```shell
npm run zip
```

Unfortunately, there isn't a way to import the app from the command line. You have to import the app using the app manager plugin.
