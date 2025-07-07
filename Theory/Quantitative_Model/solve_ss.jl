function solve_ss(param_predetermined)
    @unpack kappaK, deltaK, omega,rss = param_predetermined
    Yss = 1/(1-omega-kappaK)
    Xss =  omega/(1-omega-kappaK)
    Kss = 1/(rss+deltaK)*kappaK/(1-omega-kappaK)
    Css = 1 + rss*Kss;
    Nss = 1;
    Iss = deltaK*Kss
    Wss = 1;
    WNss = Wss*Nss;
    QK = 1;

    function ss_system(Xss,Kss)
        Nss = 1;
        Yss = Kss^kappaK*Nss^(1-omega-kappaK)*Xss^omega;

        eq = zeros(2)
        eq[1] = omega*Yss - Xss;
        eq[2] = kappaK*Yss - (rss+ deltaK)*Kss;
        return eq,Yss
    end
    results = nlsolve(x-> ss_system(x[1],x[2])[1],[1.0 1.0])
    println("converged=$(NLsolve.converged(results)) at root=$(results.zero) in "*
    "$(results.iterations) iterations and $(results.f_calls) function calls")

    Xss = results.zero[1]
    Kss = results.zero[2]
    Yss = ss_system(Xss,Kss)[2]
    Iss = deltaK*Kss;
    Css = Yss - Iss - Xss
    Qk = 1;
    Nss = 1;
    Wss = (1-omega-kappaK)*Yss/Nss
    WNss = Wss*Nss;
    Dss = Yss - Iss - Xss - WNss;
    qss = Dss/rss



    return (Yss = Yss, Xss = Xss, Kss = Kss, 
    Css = Css, Nss = Nss,Iss = Iss,WNss = WNss,
    QK = QK,
    qss = qss, Dss = Dss)

end
