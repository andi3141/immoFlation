#cd("C:/Users/andre/Google Drive/03_Eigene Dokumente/Julia/immobilien")
function immo(;
    n::Int = 30,  # number of years
    p::Float64 = 0.015, # hypothekenzins
    i::Float64 = 0.01, # inflation
    pₘ::Float64 = 5000.0, # preis pro qm
    mₘ::Float64 = 10.0,  # miete pro qm und monat
    qm::Float64 = 120.0, # qm
    nk::Float64 = 0.1,  # nebenkosten anteilig
    rr::Float64 = 0.05,  # rückstellungen für reparaturen (anteilig an Miete)
    h₀::Float64 = 100.0,  # Hausgeld (Hausmeister und Verwaltung)
    e::Float64 = 150000.0,  # Eigenkapital
    today::Int = 2021,  # start year
    b₀::Float64 = 0.0,  # jährliches budget
    ma::Int = 10,  # Mietanpassung alle ma Jahre
    ha::Int = 10, # Hausgeldanpassung alle ha Jahre
    useRent::Bool = true,  # benutze Miete für Kredit und Tilgung
    )
    #####

    # get years considered
    years = today:1:today+n-1  # jahre
    ask = append!([1.0], (1+i).^((1:n-1))) # jährliche Askontierung
    dk = append!([1.0], (1+i).^(-(1:n-1)))  # jährliche Diskontierung

    # rent and hausgeld
    h = 12*h₀*(1+i).^(1:n)  # jährliches hausgeld with inflation

    m₀ = mₘ*qm*12  # mieteinnahmen brutto erstes Jahr
    tmp = ones(ceil(Int, n/ma)) # number of rent adjustments
    tmp = ((1+i)^ma).^(0:length(tmp)-1) # amount of rent adjustments
    inds = ones(ma,1)* reshape(tmp, 1, length(tmp)) # reshape tmp to years
    inds = inds[:][1:n]  # cut off at number of years
    m = m₀.*inds  # compute brutto miete
    mₙ = m.*(1-rr) - h  # compute netto miete


    # zinsrechnungen
    kp = pₘ*qm*(1+nk)  # kaufpreis
    k = kp-e  # anfangskredit
    z, rₛ, t = [zeros(n) for _ = 1:3]  # zu zahlender zins, restschuld, jährliche Tilgung
    if useRent==true
        b = b₀.+mₙ
    else
        b = b₀*ones(n)
    end

    rₛ[1] = k  # restschuld
    for k = 1:n-1  # iterate over years
        z[k] = p*rₛ[k]  # zu zahlender zins
        t[k] = b[k] - z[k]  # tilgung
        rₛ[k+1] =  rₛ[k] - t[k]  # restschuld
    end
    z[n] = p*rₛ[n]
    t[n] = b[n] - z[n]

    # Mittelherkunft
    imw = pₘ*qm*ask
    ek = imw .- rₛ

    rₛd = rₛ.*dk
    ekd = ek.*dk

    # Renditen
    rₘ = m./qm / pₘ  # brutto mietrendite = miete/qm/kaufpreis
    rₘₙ = mₙ./qm / pₘ  # brutto mietrendite = miete/qm/kaufpreis
    rₘd = rₘ.-i  # brutto mietrendite diskontiert
    rₘₙd = rₘₙ.-i  # netto mietrendite diskontiert

    rₘₙₑ = (mₙ-z)./ e  # mietrendiete bezogen auf eingesetztes eigenkapital
    rₘₙₑd = rₘₙₑ.-i  # mietrendiete bezogen auf eingesetztes eigenkapital diskontiert
    rₑ = (ek[n]/e)^(1/n) - 1  # eigenkapitalrendite bezogen auf eigenkapital (sinkt im ersten Jahr durch Nebenkosten)



    return years, h, m, mₙ, kp, k, z, rₛ, t, b, imw, ek, rₛd, ekd, rₘ, rₘₙ, rₘd, rₘₙd, rₘₙₑ, rₘₙₑd, rₑ
end
