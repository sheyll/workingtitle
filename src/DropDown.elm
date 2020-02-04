module DropDown exposing (Msg, Model, update, view, init)

import Html exposing (Html, div, text)
import Html.Attributes exposing (class)
import Html.Events exposing (onClick, onMouseEnter, onMouseLeave)

type Msg
    = ClickItem String
    | HoveredItem (Maybe String)


type alias Model =
    { items : List String, selectedItem : String, hoveredItem : Maybe String }


init : String -> List String -> (String, Model)
init first rest =
    (first, { items = first :: rest, selectedItem = first, hoveredItem = Nothing })

update : Msg -> Model -> (String, Model)
update msg model =
    case msg of
        ClickItem x ->
            (x, { model | selectedItem = x })

        HoveredItem maybeHoveredItem ->
            (model.selectedItem, { model | hoveredItem = maybeHoveredItem })


view : (Msg -> msg) -> Model -> Html msg
view msgWarpper model =
    div
        [ class "navbar-item has-dropdown is-hoverable" ]
        [ div
            [ class "navbar-item" ]
            [ text
                ("Sprache ist "
                    ++ model.selectedItem
                    ++ Maybe.withDefault ""
                        (Maybe.map
                            (\h ->
                                if h /= model.selectedItem then
                                    " auf: " ++ h ++ " ändern"

                                else
                                    ""
                            )
                            model.hoveredItem
                        )
                    ++ "?"
                )
            ]
        , div
            [ class "navbar-dropdown" ]
            (dropDownItems msgWarpper model)
        ]


dropDownItems msgWarpper model =
    List.map (dropDownItem msgWarpper model) model.items


dropDownItem msgWarpper model itemLabel =
    let
        hovered =
            model.hoveredItem == Just itemLabel

        selected =
            model.selectedItem == itemLabel
    in
    div
        [ class
            ("navbar-item"
                ++ (if hovered then
                        " has-background-grey-lighter"

                    else if selected then
                        " has-background-primary"

                    else
                        ""
                   )
            )
        , onClick (msgWarpper (ClickItem itemLabel))
        , onMouseEnter (msgWarpper (HoveredItem (Just itemLabel)))
        , onMouseLeave (msgWarpper (HoveredItem Nothing))
        ]
        [ text itemLabel ]


