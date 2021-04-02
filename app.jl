using Dash
using DashHtmlComponents
using DashCoreComponents

#using Plots
using PlotlyJS
include("main.jl")




### output app

dropdown_options = [
    Dict("label" => "Mieteinnahmen zur Tilgung verwenden", "value" => "true", "disabled" => false)  # boolean do not work as values
]



app = dash()

app.layout = html_div() do
    html_h1(
        "Immobilienrechner",
        style = Dict("color" => "#0065bd", "textAlign" => "center"),
    ),
    html_h3(
        "A Hail Mary on Inflation",
        style = Dict("color" => "#0065bd", "textAlign" => "center"),
    ),
    #################### Wohnung ####################
    html_h2("Immobilie", style = Dict("color" => "#0065bd", "textAlign" => "center", "width" => "10%") ),

    html_div("Fläche:", style=Dict("width"=> "10%", "display"=> "inline-block") ),
    dcc_input(id = "qm", type = "number", style=Dict("width"=> "5%", "display"=> "inline-block"), value = 200.0),
    html_div(" qm", style=Dict("width"=> "84%", "display"=> "inline-block") ),

    html_div("Preis pro qm:", style=Dict("width"=> "10%", "display"=> "inline-block") ),
    dcc_input(id = "pm", type = "number", style=Dict("width"=> "5%", "display"=> "inline-block"), value = 5000.0),
    html_div(" €", style=Dict("width"=> "84%", "display"=> "inline-block") ),

    html_div("Miete pro qm:", style=Dict("width"=> "10%", "display"=> "inline-block") ),
    dcc_input(id = "mm", type = "number", style=Dict("width"=> "5%", "display"=> "inline-block"), value = 10.0),
    html_div(" € (pro Monat)", style=Dict("width"=> "84%", "display"=> "inline-block") ),

    html_div("Rückstellungen:", style=Dict("width"=> "10%", "display"=> "inline-block") ),
    dcc_input(id = "rr", type = "number", style=Dict("width"=> "5%", "display"=> "inline-block"), value = 10),
    html_div("% (für Reparaturen, anteilig an Miete)", style=Dict("width"=> "84%", "display"=> "inline-block") ),

    html_div("Hausgeld:", style=Dict("width"=> "10%", "display"=> "inline-block") ),
    dcc_input(id = "h0", type = "number", style=Dict("width"=> "5%", "display"=> "inline-block"), value = 200),
    html_div("€", style=Dict("width"=> "84%", "display"=> "inline-block") ),

    dcc_markdown(id = "wohnung-info"),

    #################### Ökonomische Rahmenbedigungen ####################
    html_h2("Ökonomische Rahmenbedigungen", style = Dict("color" => "#0065bd", "textAlign" => "center", "width" => "20%") ),

    html_div("Inflation:", style=Dict("width"=> "10%", "display"=> "inline-block") ),
    dcc_input(id = "i", type = "number", style=Dict("width"=> "5%", "display"=> "inline-block"), value = 2.0),
    html_div("% (pro Jahr)", style=Dict("width"=> "84%", "display"=> "inline-block") ),

    html_div("Mietanpassung alle:", style=Dict("width"=> "10%", "display"=> "inline-block") ),
    dcc_input(id = "ma", type = "number", style=Dict("width"=> "5%", "display"=> "inline-block"), value = 10),
    html_div("Jahre (an Inflation)", style=Dict("width"=> "84%", "display"=> "inline-block") ),

    html_div("Hausgeldanpassung alle:", style=Dict("width"=> "10%", "display"=> "inline-block") ),
    dcc_input(id = "ha", type = "number", style=Dict("width"=> "5%", "display"=> "inline-block"), value = 1),
    html_div("Jahre (an Inflation)", style=Dict("width"=> "84%", "display"=> "inline-block") ),


    dcc_graph(id = "rents", style=Dict("width"=> "48%", "display"=> "inline-block")  ),



    #################### Finanzierung ####################
    html_h2("Finanzierung", style = Dict("color" => "#0065bd", "textAlign" => "center", "width" => "10%") ),

    html_div("Laufzeit Kredit:", style=Dict("width"=> "10%", "display"=> "inline-block") ),
    dcc_input(id = "n", type = "number", style=Dict("width"=> "5%", "display"=> "inline-block"), value = 30),
    html_div("Jahre", style=Dict("width"=> "84%", "display"=> "inline-block") ),

    html_div("Hypothekenzins:", style=Dict("width"=> "10%", "display"=> "inline-block") ),
    dcc_input(id = "p", type = "number", style=Dict("width"=> "5%", "display"=> "inline-block"), value = 1.0),
    dcc_markdown("%", style=Dict("width"=> "84%", "display"=> "inline-block") ),

    html_div("Nebenkosten:", style=Dict("width"=> "10%", "display"=> "inline-block") ),
    dcc_input(id = "nk", type = "number", style=Dict("width"=> "5%", "display"=> "inline-block"), value = 10.0),
    html_div("% (anteilig am Kaufpreis)", style=Dict("width"=> "84%", "display"=> "inline-block") ),

    html_div("Eigenkapital:", style=Dict("width"=> "10%", "display"=> "inline-block") ),
    dcc_input(id = "e", type = "number", style=Dict("width"=> "5%", "display"=> "inline-block"), value = 150000.0),
    html_div("€", style=Dict("width"=> "84%", "display"=> "inline-block") ),

    html_div("Beginn der Laufzeit:", style=Dict("width"=> "10%", "display"=> "inline-block") ),
    dcc_input(id = "today", type = "number", style=Dict("width"=> "5%", "display"=> "inline-block"), value = 2021),
    html_div("(Jahr)", style=Dict("width"=> "84%", "display"=> "inline-block") ),

    html_div("Budget:", style=Dict("width"=> "10%", "display"=> "inline-block") ),
    dcc_input(id = "b0", type = "number", style=Dict("width"=> "5%", "display"=> "inline-block"), value = 0.0),
    html_div("€ (jährlich)", style=Dict("width"=> "84%", "display"=> "inline-block") ),


    dcc_checklist(id = "useRent", options = dropdown_options, value = ["true"]),



    dcc_markdown(id = "output-state"),

    dcc_graph(id = "cashflows", style=Dict("width"=> "48%")  ),
    dcc_graph(id = "capital", style=Dict("width"=> "48%", "display"=> "inline-block")  ),
    dcc_graph(id = "capital discounted", style=Dict("width"=> "48%", "display"=> "inline-block")  ),
    dcc_graph(id = "mietrenditen", style=Dict("width"=> "48%", "display"=> "inline-block")  ),
    dcc_graph(id = "ekrendite", style=Dict("width"=> "48%", "display"=> "inline-block")  )

end




callback!(
    app,
    Output("cashflows", "figure"),
    Output("rents", "figure"),
    Output("capital", "figure"),
    Output("capital discounted", "figure"),
    Output("mietrenditen", "figure"),
    Output("ekrendite", "figure"),
    Output("output-state", "children"),
    Input("n", "value"),
    Input("p", "value"),
    Input("i", "value"),
    Input("pm", "value"),
    Input("mm", "value"),
    Input("qm", "value"),
    Input("nk", "value"),
    Input("rr", "value"),
    Input("h0", "value"),
    Input("e", "value"),
    Input("today", "value"),
    Input("b0", "value"),
    Input("ma", "value"),
    Input("ha", "value"),
    Input("useRent", "value"),
) do n, p, i, pm, mm, qm, nk, rr, h0, e, today, b0, ma, ha, useRent

    # switch checkbox to bool
    if !isempty(useRent)  # is either an array of size 1 or empty
        useRent = true
    else
        useRent = false
    end

    years, h, m, mₙ, kp, k, z, rₛ, t, b, imw, ek, rₛd, ekd, rₘ, rₘₙ, rₘd, rₘₙd, rₘₙₑ, rₘₙₑd, rₑ = immo( ;n=n, p=p/100, i=i/100, pₘ=float(pm), mₘ=float(mm), qm=float(qm), nk=nk/100, rr=rr/100, h₀=float(h0), e=float(e), today=today, b₀=float(b0), ma, ha, useRent=useRent)
    # single numbers
    #rₘ = round(rₘ*100; digits=3)
    rₑi = rₑ-i/100
    rₑ = round(rₑ*100; digits=2)
    rₑi = round(rₑi*100;digits = 2)
    zinslast = scatter(;x=years, y=z,
                      mode="markers", name="Zinslast")
    tilgung = scatter(;x=years, y=t,
                      mode="markers", name="Tilgung")
    budget = scatter(;x=years, y=b,
                      mode="markers", name="Budget")
    meb = scatter(;x=years, y=m,
                      mode="markers", name="Mieteinnahmen Brutto")
    men = scatter(;x=years, y=mₙ,
                      mode="markers", name="Mieteinnahmen Netto")
    hausgeld = scatter(;x=years, y=h,
                    mode="markers", name="Hausgeld")
    immobilienwert = scatter(;x=years, y=imw,
                    mode="markers", name="Immobilienwert")
    eigk = scatter(;x=years, y=ek,
                      mode="markers", name="Eigenkapital")
    fremdk = scatter(;x=years, y=rₛ,
                      mode="markers", name="Fremdkapital")
    immobilienwertd = scatter(;x=years, y=pm*qm*ones(n),
                      mode="markers", name="Immobilienwert")
    eigkd = scatter(;x=years, y=ekd,
                      mode="markers", name="Eigenkapital")
    fremdkd = scatter(;x=years, y=rₛd,
                      mode="markers", name="Fremdkapital")

    mietrendite = scatter(;x=years, y=rₘ,
                  mode="markers", name="Mietrendite Brutto")
    nettomietrendite = scatter(;x=years, y=rₘₙ,
                  mode="markers", name="Mietrendite Netto")
    mietrendited = scatter(;x=years, y=rₘd,
                  mode="markers", name="Mietrendite Brutto diskontiert")
    nettomietrendited = scatter(;x=years, y=rₘₙd,
                  mode="markers", name="Mietrendite Netto diskontiert")
    ekrendite = scatter(;x=years, y=rₘₙₑ,
                  mode="markers", name="Eigenkapitalrendite")
    ekrendited = scatter(;x=years, y=rₘₙₑd,
                  mode="markers", name="Eigenkapitalrendite diskontiert")

    layoutCF = Layout(
                        title = "Kapitalströme",
                        xaxis_title  = "Jahr",
                        yaxis_title  = "€",
                        showlegend = true
            )
    layoutRE = Layout(
                        title = "Miete und Hausgeld",
                        xaxis_title  = "Jahr",
                        yaxis_title  = "€",
                        showlegend = true
            )
    layoutCA = Layout(
                        title = "Immobilienwert und Mittelherkunft askontiert",
                        xaxis_title  = "Jahr",
                        yaxis_title  = "€",
                        showlegend = true
            )
    layoutCAD = Layout(
                        title = "Immobilienwert und Mittelherkunft diskontiert",
                        xaxis_title  = "Jahr",
                        yaxis_title  = "€",
                        showlegend = true
                    )
    layoutME = Layout(
                        title = "Jährliche Mietrenditen",
                        xaxis_title  = "Jahr",
                        yaxis_title  = "%",
                        showlegend = true
                    )
    layoutEE = Layout(
                        title = "Jährliche Eigenkapitalrenditen",
                        xaxis_title  = "Jahr",
                        yaxis_title  = "%",
                        showlegend = true
                    )
    return  (
            # first output into cashflow plot
            Plot([zinslast, tilgung, budget], layoutCF)
            ,
            # second output into rents plot
            Plot([meb, men, hausgeld], layoutRE)
            ,
            # third output into capital plot
            Plot([immobilienwert, eigk, fremdk], layoutCA)
            ,
            # fourth output into capital plot
            Plot([immobilienwertd, eigkd, fremdkd], layoutCAD)
            ,
            # fifth output into  yield
            Plot([mietrendite, nettomietrendite,  mietrendited, nettomietrendited], layoutME)
            ,
            # sixth output into  ek yield
            Plot([ ekrendite,  ekrendited], layoutEE)
            ,
            # output as markdown output
            "

            Die **Eigenkapitalrendite** beträgt $rₑ %.

            Die **inflationsbereinigte Eigenkapitalrendite** beträgt $rₑi %.

            "
            )

end




callback!(
    app,
    Output("wohnung-info", "children"),
    Input("qm", "value"),  # Flaeche
    Input("pm", "value"),  # preis pro qm
    Input("mm", "value"),  # miete pro qm
    Input("rr", "value"),
    Input("h0", "value"),

) do qm, pm, mm, rr, h0
    kp = round(qm*pm)
    mieteB_pm = round(Int, qm*mm)
    mieteB_py = round(Int, mieteB_pm*12)
    mieteN_pm = round(Int, qm*mm*(1-rr/100) .- h0)
    mieteN_py = round(Int, mieteN_pm*12)
    return  (
            "
            Der **Kaufpreis** beträgt **$kp €**.

            Die **Bruttomiete** beträgt gegenwärtig **$mieteB_pm €** pro Monat, bzw. **$mieteB_py €** pro Jahr.

            Die **Nettomiete** beträgt gegnwärtig **$mieteN_pm €** pro Monat, bzw. **$mieteN_py €** pro Jahr.
            "
            )
end








run_server(app, "127.0.0.1", 8050, debug=true)
