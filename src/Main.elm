module Main exposing (..)

import Browser
import Html exposing (Html, button, div, text, nav, img, span, a)
import Html.Events exposing (onClick, onMouseEnter, onMouseLeave)
import Html.Attributes exposing (class, href, attribute, width, height, src, id)

type alias Model =
    { language : String
    , isBurgerOpened : Bool
    , isLanguageDropdownOpened : Bool
    , hoveredLanguage : Maybe String
    }

main =
  Browser.sandbox { init = Model "Deutsch" False False Nothing, update = update, view = view }

type Msg = ToggleBurger | ToggleDropdown | SelectLanguage String | HoverLanguage (Maybe String)

update msg model =
  case msg of
    ToggleBurger ->
      { model | isBurgerOpened = not model.isBurgerOpened }

    ToggleDropdown ->
      { model | isLanguageDropdownOpened = not model.isLanguageDropdownOpened }

    SelectLanguage language ->
      { model | language = language }

    HoverLanguage maybeLanguage ->
      { model | hoveredLanguage = maybeLanguage }

navbarContent model = [ navbarBrand model, navbarMenu model]

navbarBrand model =
  div
    [ class "navbar-brand" ]
    [ a
        [ class "navbar-item", href "https://bulma.io" ]
        [ img 
            [ src "https://bulma.io/images/bulma-logo.png", width 112, height 28]
            []
        ]
    , a
        [ class ("navbar-burger burger" ++
                 (if model.isBurgerOpened then " is-active" else ""))
        , attribute "data-target" "navbarBasicExample"
        , onClick ToggleBurger
        ]
        [ span [] []
        , span [] []
        , span [] []
        ]
    ]

dropDownLanguageItem language model =
  let hovered = case model.hoveredLanguage of
                       Nothing -> False
                       Just hlanguage -> hlanguage == language
      selected = model.language == language
  in
    div
      [ class ("navbar-item" ++
          if      hovered  then " has-background-grey-lighter"
          else if selected then " has-background-primary"
          else ""
        )
      , onClick (SelectLanguage language)
      , onMouseEnter (HoverLanguage (Just language))
      , onMouseLeave (HoverLanguage Nothing)
      ]
      [ text language ]

navbarMenu model =
  div
    [ class ("navbar-menu" ++ (if model.isBurgerOpened then " is-active" else "")), id "navbarBasicExample" ]
    [ div
        [ class "navbar-start" ]
        [ div
            [ class "navbar-item has-dropdown is-hoverable" ]
            [ div
                [ class "navbar-item" ]
                [ text ("Sprache " ++ model.language ++ " ändern!") ]
            , div
                [ class "navbar-dropdown" ]
                [ dropDownLanguageItem "Deutsch" model
                , dropDownLanguageItem "English" model
                ]
            ]
        ]
    ]

view model =
  nav
    [ class "navbar" ]
    (navbarContent model)
