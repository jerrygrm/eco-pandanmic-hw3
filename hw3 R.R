library(quantmod)
library(data.table)
library(DMwR)
library(mice)
stocklist <- c("DJI","^N225","GOOG","MSFT","AMZN","AAPL","399001.SZ","^GDAXI")
getSymbols(stocklist, from='2020-03-01',to='2020-06-01')
dji<-as.data.table(Ad(DJI))
n225<-as.data.table(Ad(N225))
goog<-as.data.table(Ad(GOOG))
msft<-as.data.table(Ad(MSFT))
amzn<-as.data.table(Ad(AMZN))
aapl<-as.data.table(Ad(AAPL))
china<-as.data.table(Ad(`399001.SZ`))
dax<-as.data.table(Ad(GDAXI))
sum<-join_all(list(dji,n225,goog,msft,amzn,aapl,china,dax), by='index', type='left')
colnames(sum)<-c("Date","US","Japan","Google","Microsoft","Amazon","Apple","China","Germany")
sum<-na.omit(sum)
aa <- subset(sum, select = -Date )
myfreq <- c(0.05,0.05, 0.075, 0.075, 0.1,0.1, 0.125,0.125)
bb<-ampute(aa,prop=0.5,freq=myfreq,mech="MAR")
bb$freq
[1] 0.07142857 0.07142857 0.10714286 0.10714286 0.14285714 0.14285714 0.17857143
[8] 0.17857143
knnImpute<-knnImputation(bb$amp, scale=T,k =3, meth = 'median')
knnImpute$Date<-sum$Date
knnImpute<- knnImpute %>% select(Date,US,Japan,Google,Microsoft,Amazon,Apple,China,Germany)
write.table(knnImpute, file = "resulttable.csv")















