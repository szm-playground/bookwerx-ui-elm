module Transactions.Views.Edit exposing (view)

import Html exposing (Html, a, br, button, div, h3, input, table, tbody, td, text, th, thead, tr)
import Html.Attributes exposing (class, href, id, type_, value)
import Html.Events exposing (onClick, onInput)
import RemoteData

import Types exposing
    ( BWCore_Error
    , Model
    , Msg(SubmitUpdatedTransaction, UpdateTransactionDesc)
    , Transaction
    , TransactionEditHttpResponse(..)
    )

view : Model -> Html Msg
view model =
    div [ id "transactions-edit"]
        [ a [ href "/transactions" ] [ text "Transactions index" ]
        , h3 [] [ text "Edit Transaction" ]
        , viewTransactionOrError model
        ]


viewTransactionOrError : Model -> Html Msg
viewTransactionOrError model =
    case model.wdTransaction of
        RemoteData.NotAsked ->
            h3 [] [ text "Not Asked..." ]

        RemoteData.Loading ->
            h3 [ class "loader" ] [ text "Loading..." ]

        RemoteData.Success aehr ->
            case aehr of
                ValidTransactionEditResponse wdTransaction ->
                    editForm model.editTransaction

                ErrorTransactionEditResponse errors ->
                    viewErrors errors

        RemoteData.Failure httpError ->
            h3 [] [ text "Transaction error..." ]

viewErrors : List BWCore_Error -> Html Msg
viewErrors errors =
    div [ id "errors"]
        [ h3 [] [ text "Errors" ]
        , table []
            [ thead [][viewTableHeader]
            , tbody [] (List.map viewError errors)
            ]
        ]

viewError : BWCore_Error -> Html Msg
viewError error =
    tr []
        [ td []
            [ text error.key ]
        , td []
            [ text error.value ]
        ]

viewTableHeader : Html Msg
viewTableHeader =
    tr []
        [ th []
            [ text "key" ]
        , th []
            [ text "value" ]
        ]

editForm : Transaction -> Html Msg
editForm transaction =
    Html.form []
        [ div []
            [ text "Description"
            , br [][]
            , input
                [ type_ "text"
                , value transaction.desc
                , onInput (UpdateTransactionDesc)
                ]
                []
            ]
        , br [][]
        , div []
            [ button [ onClick (SubmitUpdatedTransaction) ]
                [ text "Submit" ]
            ]
        ]