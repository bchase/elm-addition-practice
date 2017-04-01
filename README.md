# Addition Drills, made with Elm

## Play with it locally

First, you'll need to have [Elm installed](https://guide.elm-lang.org/install.html). If you're already using `npm`, it's as simple as:

```
$ npm install -g elm
```

Next, clone this repo and install the necessary packages:

```
$ git clone https://github.com/bchase/elm-addition-practice
$ cd elm-addition-practice
$ elm package install
```

Then open up `src/AdditionPractice.elm` and use either `elm reactor` or `elm make` to get things running:

```
$ elm reactor
```

```
$ elm make src/AdditionPractice.elm --output=foo.html
$ open foo.html
```

Have fun!
