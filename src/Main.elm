module Main exposing (..)

import DropDown
import Browser
import Html exposing (Html, a, div, img, nav, span, text)
import Html.Attributes exposing (attribute, class, height, href, id, src, width)
import Html.Events exposing (onClick)


type alias Model =
    { language : String
    , isBurgerOpened : Bool
    , isLanguageDropdownOpened : Bool
    , languageDropDownModel : DropDown.Model
    }


main : Program () Model Msg
main =
    let
       (selectedItem, dropDownModel) = DropDown.init "Deutsch" [ "English", "Spanisch" ]
    in Browser.sandbox { init = Model selectedItem False False dropDownModel, update = update, view = view }


type Msg
    = ToggleBurger
    | LanguageDropDownMessage DropDown.Msg


update :
    Msg
    -> Model
    -> Model
update msg model =
    case msg of
        ToggleBurger ->
            { model | isBurgerOpened = not model.isBurgerOpened }

        LanguageDropDownMessage m ->
            let
                (newSelection, newLanguageModel) = DropDown.update m model.languageDropDownModel
            in
                { model | languageDropDownModel = newLanguageModel, language = newSelection }


navbarContent : Model -> List (Html Msg)
navbarContent model =
    [ navbarBrand model, navbarMenu model, navbarEnd model]


navbarBrand : Model -> Html Msg
navbarBrand model =
    div
        [ class "navbar-brand" ]
        [ a
            [ class "navbar-item", href "https://bulma.io" ]
            [ img
                [ src "https://bulma.io/images/bulma-logo.png", width 112, height 28 ]
                []
            ]
        , a
            [ class
                ("navbar-burger burger"
                    ++ (if model.isBurgerOpened then
                            " is-active"

                        else
                            ""
                       )
                )
            , attribute "data-target" "navbarBasicExample"
            , onClick ToggleBurger
            ]
            [ span [] []
            , span [] []
            , span [] []
            ]
        ]


navbarMenu : Model -> Html Msg
navbarMenu model =
    div
        [ class
            ("navbar-menu"
                ++ (if model.isBurgerOpened then
                        " is-active"

                    else
                        ""
                   )
            )
        , id "navbarBasicExample"
        ]
        [ div
            [ class "navbar-start" ]
            [ DropDown.view LanguageDropDownMessage model.languageDropDownModel
            ]
        ]

navbarEnd : { a | language : String } -> Html msg
navbarEnd model = div [class "navbar-end"] [div [class "navbar-item"] [text model.language]]

view : Model -> Html Msg
view model =
    nav
        [ class "navbar has-background-primary" ]
        (navbarContent model)

