{-# LANGUAGE OverloadedStrings #-}
module MyAntigen where

import Antigen (
                -- Rudimentary imports
                AntigenConfig (..)
              , defaultConfig
              , bundle
              , antigen
                -- If you want to source a bit trickier plugins
              , ZshPlugin (..)
              , antigenSourcingStrategy
              , filePathsSourcingStrategy
              )
bundles =
  [ bundle "Tarrasch/zsh-functional"
  , bundle "Tarrasch/zsh-bd"
  , bundle "Tarrasch/zsh-command-not-found"
  , bundle "Tarrasch/zsh-colors"
  , bundle "Tarrasch/zsh-autoenv"
  , bundle "Tarrasch/zsh-i-know"
  , bundle "Tarrasch/pure"
  , bundle "Tarrasch/zsh-mcd"
  , bundle "zsh-users/zsh-syntax-highlighting"
  --  missing zsh.plugin file, fix it!
  --, bundle "zsh-users/zsh-history-substring-search"
  , bundle "jocelynmallon/zshmarks"
  , bundle "chrissicool/zsh-256color"
  , bundle "Tarrasch/zsh-colors"
  , bundle "peterhurford/git-aliases.zsh"
  , bundle "unixorn/git-extra-commands"
  --  , bundle "thvitt/tvline"
  -- , developFromFileSystem "/home/arash/repos/zsh-snakebite-completion"
  ]

config = defaultConfig {plugins = bundles}

main :: IO ()
main = antigen config
