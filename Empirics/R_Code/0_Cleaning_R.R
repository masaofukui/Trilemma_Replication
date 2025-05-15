packages_vector <- c("foreign", "sandwich","ggplot2", "boot", "zoo", 
                     "quantreg", "dummies", "stargazer", "lmtest", "expm","coefplot",
                     "OpenMx","Matrix","foreign","MASS","reshape2","AER",
                     "plyr","systemfit","ivpack","quantmod","xtable","boot","mFilter",
                     "dynlm","vars","nleqslv","vars","dplyr","forecast","fUnitRoots","tidyr","plm",
                     "WDI","conflicted","data.table","readxl","stringr","countrycode","modeest")
#install.packages(packages_vector)
#install.packages('data.table', type='source')
lapply(packages_vector, require, character.only = TRUE) # the "lapply" function means "apply this function to the elements of this list or more restricted data type"
rm(list = ls())
conflict_prefer("select", "dplyr")
conflict_prefer("melt", "reshape2")
conflict_prefer("rename", "dplyr")
conflict_prefer("mutate", "dplyr")
conflict_prefer("summarise", "dplyr")
conflict_prefer("filter", "dplyr")
load_WB = 0
# Set the directory to the location of this R file
script.dir <- dirname(rstudioapi::getSourceEditorContext()$path)
setwd(script.dir)
#setwd("/Users/fukui/Dropbox (MIT)/Trilemma/R/")
df2 <- fread("../OriginalData/IFS/IFS_12-11-2021 19-43-32-15_panel/IFS_12-11-2021 19-43-32-15_panel.csv")



# drop monthy observation
df2 <- df2[,!"Status"]
df3 <- df2[- grep("M", df2$"Time Period"),]
df3 <- df3[- grep("Q", df3$"Time Period"),]
df4 <- df3 %>% dplyr:: rename("Time.Period" = "Time Period")
names(df4)[3] <- "Time.Period"
names(df4)[2] <- "Country.Code"
name.list <- as.data.frame(names(df4))

classification_monthly <- read_excel("../OriginalData/Exchange_rate_classification/ERA_Classification_Monthly_1940-2019.xlsx",sheet = "Fine")
classification_monthly.name1 <- classification_monthly[4,]
classification_monthly.name1 <- as.character(classification_monthly.name1)
classification_monthly.name2 <- classification_monthly[5,]
classification_monthly.name2 <- as.character(classification_monthly.name2)
classification_monthly.name <- paste(classification_monthly.name1, classification_monthly.name2,sep=" ")
classification_monthly.name <- str_remove(classification_monthly.name,"NA ")
names(classification_monthly) <- classification_monthly.name
classification_monthly <- classification_monthly[7:nrow(classification_monthly),2:ncol(classification_monthly)]
names(classification_monthly)[1] <- "Time.Period"
classification_monthly <- melt(classification_monthly, id=c("Time.Period"))
classification_monthly <- rename(classification_monthly,Exrate.Regime = value,Country.Name = variable)
classification_monthly$Exrate.Regime <- as.numeric(classification_monthly$Exrate.Regime)
classification_monthly$Country.Code <- countrycode(classification_monthly$Country.Name, origin = 'country.name', destination = 'imf')
classification_monthly.not.matched <- unique(classification_monthly[is.na(classification_monthly$Country.Code),'Country.Name'])
classification_monthly$Time.Period <- as.numeric(substr(classification_monthly$Time.Period,1,4))
classification_monthly <- classification_monthly %>% mutate(peg = ifelse(Exrate.Regime<=8,1,0))
classification_monthly <- classification_monthly %>% group_by(Country.Code, Time.Period) %>% dplyr:: summarise(peg_cont = mean(peg),Exrate.Regime = (mfv(Exrate.Regime)))
classification_monthly <- classification_monthly %>% group_by(Country.Code, Time.Period) %>% mutate(Exrate.Regime = max(Exrate.Regime))
classification_monthly <- classification_monthly %>% distinct()

df4$Time.Period <- as.numeric(data.matrix(df4$Time.Period))
df5 <- inner_join(df4, classification_monthly, by = c("Country.Code", "Time.Period"))
#write.dta(df5,"../WorkingData/Cleaned/temp_original.dta")

vname = as.data.frame(names(df5))

#All in Euro
df5_name <- rename(df5, CPI = "Prices, Consumer Price Index, All items, Index (PCPI_IX)", 
                   population = "Population, Persons, Number of (LP_PE_NUM)",
                   Export.price = "Prices, Export Price Index, All Commodities, Index (PXP_IX)",
                   Import.price = "Prices, Import Price Index, All Commodities, Index (PMP_IX)", 
                   Imports.nominal = "External Trade, Goods, Value of Imports, Cost Insurance Freight (CIF), Domestic Currency (TMG_CIF_XDC)", 
                   Exports.nominal = "External Trade, Goods, Value of Exports, Free on Board (FOB), Domestic Currency (TXG_FOB_XDC)",
                   Exports.nominal.USD = "External Trade, Goods, Value of Exports, Free on Board (FOB), US Dollars (TXG_FOB_USD)",
                   Imports.nominal.USD = "External Trade, Goods, Value of Imports, Cost, Insurance, Freight (CIF), US Dollars (TMG_CIF_USD)",
                   Nominal.Effective.Exrate = "Exchange Rates, Nominal Effective Exchange Rate, Index (ENEER_IX)",
                   Real.Effective.Exrate = "Exchange Rates, Real Effective Exchange Rate based on Consumer Price Index, Index (EREER_IX)",
                   Exrate.per.USD = "Exchange Rates, Domestic Currency per U.S. Dollar, Period Average, Rate (ENDA_XDC_USD_RATE)",
                   TBill.rate = "Financial, Interest Rates, Government Securities, Treasury Bills, Percent per annum (FITB_PA)",
                   Money.Market.Rate = "Financial, Interest Rates, Money Market, Foreign Currency, Percent per Annum (FIMM_FX_PA)",
                   imports.unit.value.IFS = "External Trade, Goods, Deflator/Unit Value of Imports, Cost Insurance Freight (CIF), Index (TMG_D_CIF_IX)",
                   imports.quantity.IFS = "External Trade, Goods, Volume of Imports, Cost Insurance Freight (CIF), Index (TMG_R_CIF_IX)",
                   exports.unit.value.IFS = "External Trade, Goods, Deflator/Unit Value of Exports, Free on Board (FOB), Index (TXG_D_FOB_IX)",
                   exports.quantity.IFS = "External Trade, Goods, Volume of Exports, Free on Board (FOB), Index (TXG_R_FOB_IX)",
                   monetary.policy = "Financial, Interest Rates, Monetary Policy-Related Interest Rate, Percent per annum (FPOLM_PA)")



df6 <- select(df5_name,Time.Period,Country.Code,peg_cont,Exrate.Regime, CPI,
              population,Export.price,Import.price,
              Imports.nominal,Imports.nominal.USD,Exports.nominal,Exports.nominal.USD,Exrate.per.USD,Nominal.Effective.Exrate,
              Real.Effective.Exrate,
              TBill.rate, 
              monetary.policy,
              Money.Market.Rate,starts_with("imports."),starts_with("exports."))


# higher value means DEPRECIATION of its currency
df6 <- df6 %>% dplyr:: mutate(Real.Effective.Exrate = 1/Real.Effective.Exrate)
df6 <- df6 %>% dplyr:: mutate(Nominal.Effective.Exrate = 1/Nominal.Effective.Exrate)


df6$ISO.Code <- countrycode(df6$Country.Code,origin = 'imf',dest='iso3c')
df6$region <- countrycode(df6$Country.Code,origin = 'imf',dest='continent')

df6 <- df6 %>% dplyr:: relocate(ISO.Code,Time.Period)
df6 <- df6 %>% dplyr::filter(!is.na(ISO.Code))
a <- df6 %>% dplyr::select(ISO.Code,Time.Period) %>% distinct()
b <-  df6 %>% group_by(ISO.Code,Time.Period) %>% dplyr:: filter(n()>1)

############################################################################
# Merge export, import from World Bank
############################################################################

if (load_WB == 1){
  Data_WB <- WDI(country = "all",indicator = c("NE.EXP.GNFS.ZS","NE.IMP.GNFS.ZS","BN.CAB.XOKA.GD.ZS","TM.UVI.MRCH.XD.WD",
                                               "TX.UVI.MRCH.XD.WD","TT.PRI.MRCH.XD.WD","NE.IMP.GNFS.KD","NE.EXP.GNFS.KD",
                                               "NY.GDP.PCAP.KD","FP.CPI.TOTL.ZG","SL.UEM.TOTL.ZS","SL.UEM.TOTL.NE.ZS",
                                               "NE.GDI.TOTL.KD","TX.VAL.MRCH.CD.WT","TM.VAL.MRCH.CD.WT","FR.INR.RINR",
                                               "CM.MKT.TRAD.GD.ZS","FS.AST.PRVT.GD.ZS","NE.CON.TOTL.KD","NY.GDP.MKTP.KD",
                                               "NE.EXP.GNFS.CD","NE.EXP.GNFS.CN","NY.EXP.CAPM.KN",
                                               "NE.IMP.GNFS.CD", "NE.IMP.GNFS.CN","NE.IMP.GNFS.KN",
                                               "NV.IND.MANF.KD", "NV.SRV.TOTL.KD", "BX.GSR.NFSV.CD","BM.GSR.NFSV.CD",
                                               "NV.IND.MANF.ZS","NV.SRV.TOTL.ZS"),extra= T)
  Data_WB <- Data_WB %>% dplyr:: select(Time.Period = year,ISO.Code = iso3c, exports.share.WB = NE.EXP.GNFS.ZS, imports.share.WB = NE.IMP.GNFS.ZS, 
                                        Current.Account.per.GDP = BN.CAB.XOKA.GD.ZS, exports.price.WB = TX.UVI.MRCH.XD.WD,
                                        imports.price.WB = TM.UVI.MRCH.XD.WD, Terms.of.Trade.WB = TT.PRI.MRCH.XD.WD,
                                        imports.WB = NE.IMP.GNFS.KD,exports.WB = NE.EXP.GNFS.KD, GDP.per.capita = NY.GDP.PCAP.KD,
                                        inflation.CPI = FP.CPI.TOTL.ZG, unemp.ILO = SL.UEM.TOTL.ZS,unemp.national=SL.UEM.TOTL.NE.ZS,
                                        investment =NE.GDI.TOTL.KD,exports.WTO =  TX.VAL.MRCH.CD.WT, imports.WTO =  TM.VAL.MRCH.CD.WT, real.rate = FR.INR.RINR,
                                        stock.per.GDP =  CM.MKT.TRAD.GD.ZS, credit =  FS.AST.PRVT.GD.ZS,  RealC = NE.CON.TOTL.KD,RGDP.WB = NY.GDP.MKTP.KD,
                                        exports.WB.curUSD = NE.EXP.GNFS.CD, exports.WB.curLCU =  NE.EXP.GNFS.CN, exports.WB.conLCU = NY.EXP.CAPM.KN,
                                        imports.WB.curUSD = NE.IMP.GNFS.CD, imports.WB.curLCU =  NE.IMP.GNFS.CN, imports.WB.conLCU = NE.IMP.GNFS.KN,
                                        service.gdp = NV.SRV.TOTL.KD, manuf.gdp = NV.IND.MANF.KD,service.export =  BX.GSR.NFSV.CD,service.import =  BM.GSR.NFSV.CD,
                                        manuf.share = NV.IND.MANF.ZS, service.share = NV.SRV.TOTL.ZS)
  saveRDS(Data_WB,"../WorkingData/WorldBank/WB_R_download.rds")
}else{
  Data_WB<- readRDS("../WorkingData/WorldBank/WB_R_download.rds")
}
df10 <- left_join(df6,Data_WB,by=c("ISO.Code","Time.Period"))



############################################################################
# Merge anchor currency
############################################################################
curr.list <- c("USD","GBP","FRF","DEM","YEN","EUR")
pegfun <- function(filename) {
  d <- read_excel("../OriginalData/Exchange_rate_classification/Anchor_monthly_1946-2019.xlsx",sheet=filename,skip = 5)
  d <-	gather(d, ISO.Code, temp,-"ISO3 Code")
  d <- rename(d, Time.Period_temp = "ISO3 Code")
  d$temp <- as.numeric(d$temp)
  
  d$month <- as.numeric( sub(".*M", "", d$Time.Period_temp)) 
  d$Time.Period <- as.numeric(substr(d$Time.Period_temp,1,4))
  d <- dplyr::filter(d,!is.na(Time.Period))
  dmonth <- d
  
  d<- summarise(group_by(d,Time.Period,ISO.Code), sum(temp))
  d <- dplyr:: filter(d,Time.Period>=1946)
  d <- d[,1:3]
  d[,3] <- d[,3] >=6
  d[,3] <- 1*d[,3]
  names(d)[3] <- paste("peg_",filename,sep="")
  
  dmonth <-dmonth %>% dplyr:: filter(month == 12)
  dmonth <- dmonth[,c(2,3,5)]
  names(dmonth)[2] <- paste("peg_Dec_",filename,sep="")
  
  d <- left_join(d,dmonth,by=c("Time.Period","ISO.Code"))
  return(d)
}


for (i in 1:length(curr.list)){
  assign(curr.list[i],pegfun(curr.list[i]))
}

anchor <- USD
anchor <-left_join(anchor,GBP,by=c("ISO.Code","Time.Period"))
anchor <-left_join(anchor,FRF,by=c("ISO.Code","Time.Period"))
anchor <-left_join(anchor,DEM,by=c("ISO.Code","Time.Period"))
anchor <-left_join(anchor,YEN,by=c("ISO.Code","Time.Period"))
anchor <-left_join(anchor,EUR,by=c("ISO.Code","Time.Period"))
anchor <- anchor %>% dplyr:: mutate(peg_all = peg_USD + peg_GBP + peg_FRF + peg_DEM + peg_EUR )
anchor <- anchor %>% dplyr:: mutate(peg_USD = ifelse(peg_all > 1, peg_Dec_USD,peg_USD))
anchor <- anchor %>% dplyr:: mutate(peg_GBP = ifelse(peg_all > 1, peg_Dec_GBP,peg_GBP))
anchor <- anchor %>% dplyr:: mutate(peg_FRF = ifelse(peg_all > 1, peg_Dec_FRF,peg_FRF))
anchor <- anchor %>% dplyr:: mutate(peg_DEM = ifelse(peg_all > 1, peg_Dec_DEM,peg_DEM))
anchor <- anchor %>% dplyr:: mutate(peg_EUR = ifelse(peg_all > 1, peg_Dec_EUR,peg_EUR))
anchor <- anchor %>% dplyr:: select(-starts_with("peg_Dec"))
anchor <- anchor %>% dplyr:: select(-peg_all)

df12 <- left_join(df10,anchor,by=c("ISO.Code","Time.Period"))
df12$peg_DEM_EUR <- (df12$peg_DEM) + (df12$peg_EUR)

############################################################################
# Merge BIS exchange rate
############################################################################

Nominal.Effective.BIS <- read_excel("../OriginalData/Exchangerate_BIS/narrow.xlsx",skip=4,sheet = "Nominal")
Nominal.Effective.BIS$Time.Period <- as.numeric(substring(Nominal.Effective.BIS$"...1", 1, 4))
Nominal.Effective.BIS <- select(Nominal.Effective.BIS, -...1)
Nominal.Effective.BIS.sum <-summarize_all(group_by(Nominal.Effective.BIS,Time.Period),funs(mean))
Nominal.Effective.BIS <- gather(Nominal.Effective.BIS.sum, ISO2.Code, BIS.Nominal.Effective, starts_with("NN"))
Nominal.Effective.BIS$ISO2.Code <- substr(Nominal.Effective.BIS$ISO2.Code,3,4)
Nominal.Effective.BIS$ISO.Code <- countrycode(Nominal.Effective.BIS$ISO2.Code,origin = "iso2c",dest = "iso3c")
Nominal.Effective.BIS <- Nominal.Effective.BIS %>% dplyr:: select(-ISO2.Code) 

Real.Effective.BIS <- read_excel("../OriginalData/Exchangerate_BIS/narrow.xlsx",skip=4,sheet = "Real")
Real.Effective.BIS$Time.Period <- as.numeric(substring(Real.Effective.BIS$...1, 1, 4))
Real.Effective.BIS <- select(Real.Effective.BIS, -...1)
Real.Effective.BIS.sum <-summarize_all(group_by(Real.Effective.BIS,Time.Period),funs(mean))
Real.Effective.BIS <- gather(Real.Effective.BIS.sum, ISO2.Code, BIS.Real.Effective, starts_with("RN"))
Real.Effective.BIS$ISO2.Code <- substr(Real.Effective.BIS$ISO2.Code,3,4)
Real.Effective.BIS$ISO.Code <- countrycode(Real.Effective.BIS$ISO2.Code,origin = "iso2c",dest = "iso3c")
Real.Effective.BIS <- Real.Effective.BIS %>% dplyr:: select(-ISO2.Code) 

Effective.BIS <- left_join(Nominal.Effective.BIS,Real.Effective.BIS,by=c("Time.Period","ISO.Code"))
df14 <- left_join(df12,Effective.BIS,by=c("Time.Period","ISO.Code"))                

## higher value means DEPRECIATION
df14 <- df14 %>% mutate(BIS.Nominal.Effective = 100/BIS.Nominal.Effective,BIS.Real.Effective = 100/BIS.Real.Effective)

##############################################################
# Merge BIS exchange rate
##############################################################
list <- c("USA","GBR","FRA","DEU")
df15 <- df14
curfun <- function(name){
  d <- dplyr:: filter(df14,ISO.Code == paste(name))
  d <- select(d, BIS.Nominal.Effective,Time.Period)
  names(d)[1] <-  paste(list[i],".BIS.Nominal",sep="")
  a <- log(d[,1])
  a <- as.vector(unlist(a[,1]))
  d$temp <- c(NA,diff(a)) 
  names(d)[3] <-  paste("dlog.",list[i],".BIS.Nominal",sep="")
  return(d)
}
curfun.real <- function(name){
  d <- dplyr:: filter(df14,ISO.Code == paste(name))
  d <- select(d, BIS.Real.Effective,Time.Period)
  names(d)[1] <-  paste(list[i],".BIS.Real",sep="")
  a <- log(d[,1])
  a <- as.vector(unlist(a[,1]))
  d$temp <- c(NA,diff(a)) 
  names(d)[3] <-  paste("dlog.",list[i],".BIS.Real.Rate",sep="")
  return(d)
}


for (i in 1:length(list)){
  assign(list[i],curfun(list[i]))
}
df15 <- left_join(df15,USA,by="Time.Period")
df15 <- left_join(df15,GBR,by="Time.Period")
df15 <- left_join(df15,FRA,by="Time.Period")
df15 <- left_join(df15,DEU,by="Time.Period")
for (i in 1:length(list)){
  assign(list[i],curfun.real(list[i]))
}
df15 <- left_join(df15,USA,by="Time.Period")
df15 <- left_join(df15,GBR,by="Time.Period")
df15 <- left_join(df15,FRA,by="Time.Period")
df15 <- left_join(df15,DEU,by="Time.Period")

##############################################################
# Merge German, FRA, GBR exchange rate to USD
##############################################################
USD.per.Euro <- read.csv("../OriginalData/Exchange_Rate_USD_Euro/DEXUSEU.csv")
USD.per.Euro$Time.Period <- as.numeric(substr(USD.per.Euro$DATE,1,4))
USD.per.Euro$DATE <- NULL
Euro.per.USD <- USD.per.Euro
Euro.per.USD$Exrate.per.USD <- 1/as.numeric(levels(USD.per.Euro$DEXUSEU))[USD.per.Euro$DEXUSEU] 
Euro.per.USD$DEXUSEU <- NULL


Ex.rate.DEU.perUSD <- dplyr:: filter(df15,ISO.Code == "DEU")
Ex.rate.DEU.perUSD <- select(Ex.rate.DEU.perUSD,Time.Period,Exrate.per.USD)
Ex.rate.DEU.perUSD <- dplyr:: filter(Ex.rate.DEU.perUSD,Time.Period<=1998)
# append Euro
Ex.rate.DEU.perUSD <- dplyr:: bind_rows(Ex.rate.DEU.perUSD, Euro.per.USD)
Ex.rate.DEU.perUSD <- dplyr:: rename(Ex.rate.DEU.perUSD, DEU.per.USD = Exrate.per.USD)

#France
Ex.rate.FRA.perUSD <- dplyr:: filter(df15,ISO.Code == "FRA")
Ex.rate.FRA.perUSD <- select(Ex.rate.FRA.perUSD,Time.Period,Exrate.per.USD)
Ex.rate.FRA.perUSD <- dplyr:: rename(Ex.rate.FRA.perUSD, FRA.per.USD = Exrate.per.USD)

#UK
Ex.rate.GBR.perUSD <- dplyr:: filter(df15,ISO.Code == "GBR")
Ex.rate.GBR.perUSD <- select(Ex.rate.GBR.perUSD,Time.Period,Exrate.per.USD)
Ex.rate.GBR.perUSD <- dplyr:: rename(Ex.rate.GBR.perUSD, GBR.per.USD = Exrate.per.USD)

df16 <- df15
df16 <- left_join(df16,Ex.rate.DEU.perUSD,by="Time.Period")
df16 <- left_join(df16,Ex.rate.FRA.perUSD,by="Time.Period")
df16 <- left_join(df16,Ex.rate.GBR.perUSD,by="Time.Period")

# IMF DOT exports and imports data --------------------------------------------------------------------

DOT.data <- read.csv("../OriginalData/IMF_DOT/DOT_06-03-2021 04-19-14-08_panel/DOT_06-03-2021 04-19-14-08_panel.csv")
names(DOT.data)[6] <- "exports.DOT"
names(DOT.data)[8] <- "imports.DOT"
DOT.data <- dplyr:: select(DOT.data, Country.Code, Time.Period,exports.DOT,imports.DOT, )

df16 <- dplyr:: left_join(df16,DOT.data,by=c("Country.Code","Time.Period"))

write.dta(df16,"../WorkingData/Cleaned/Dataset.dta")

