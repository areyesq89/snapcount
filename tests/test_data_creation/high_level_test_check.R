#check higher level functions in Snapcount

library(snapcount)

######Merge testing
sb <- SnaptronQueryBuilder$new()

urls1=list("http://snaptron.cs.jhu.edu/encode1159/snaptron?regions=chr1:1879786-1879786&either=2&rfilter=strand:-",
           "http://snaptron.cs.jhu.edu/rpc/snaptron?regions=chr1:1879786-1879786&either=2&rfilter=strand:-")

len<-length(urls1)
sbs1<-lapply(urls1, function(g) { sb$from_url(g)$clone(deep=TRUE) })

check_junction_union_output<-junction_union(sbs1[[1]],sbs1[[2]])

test_junction_union_output<-readRDS(file="test_junction_union_output.rds")
all.equal(test_junction_union_output, check_junction_union_output)


######Intersection testing
sb <- SnaptronQueryBuilder$new()

urls1=list("http://snaptron.cs.jhu.edu/encode1159/snaptron?regions=chr1:1879786-1879786&either=2&rfilter=strand:-",
           "http://snaptron.cs.jhu.edu/rpc/snaptron?regions=chr1:1879786-1879786&either=2&rfilter=strand:-")

len<-length(urls1)
sbs1<-lapply(urls1, function(g) { sb$from_url(g)$clone(deep=TRUE) })

check_junction_intersection_output<-junction_intersection(sbs1[[1]],sbs1[[2]])

test_junction_intersection_output<-readRDS(file="test_junction_intersection_output.rds")
all.equal(test_junction_intersection_output, check_junction_intersection_output)



####SSC testing
#Shared Sample Count (SSC) high level function fails
sb <- SnaptronQueryBuilder$new()
urls1=list("http://snaptron.cs.jhu.edu/gtex/snaptron?regions=chr1:1879786-1879786&either=2&rfilter=strand:-",
           "http://snaptron.cs.jhu.edu/gtex/snaptron?regions=chr1:9664595-9664595&either=2&rfilter=strand:+",
           "http://snaptron.cs.jhu.edu/gtex/snaptron?regions=chr6:32831148-32831148&either=2&rfilter=strand:-")
urls2=c("http://snaptron.cs.jhu.edu/gtex/snaptron?regions=chr1:1879903-1879903&either=1&rfilter=strand:-",
        "http://snaptron.cs.jhu.edu/gtex/snaptron?regions=chr1:9664759-9664759&either=1&rfilter=strand:+",
        "http://snaptron.cs.jhu.edu/gtex/snaptron?regions=chr6:32831182-32831182&either=1&rfilter=strand:-")

len<-length(urls1)
sbs1<-lapply(urls1, function(g) { sb$from_url(g)$clone(deep=TRUE) })
sbs2<-lapply(urls2, function(g) { sb$from_url(g)$clone(deep=TRUE) })
ssc_inputs<-lapply(1:length(sbs1), function(g) { list(sbs1[[g]], sbs2[[g]])})
check_ssc_output <- shared_sample_counts(ssc_inputs[[1]], ssc_inputs[[2]], ssc_inputs[[3]])

test_ssc_output<-readRDS(file="test_ssc_output.rds")
all.equal(test_ssc_output, check_ssc_output)


########JIR testing
sb1 <- SnaptronQueryBuilder$new()
sb1<-sb1$from_url("http://snaptron.cs.jhu.edu/srav2/snaptron?regions=chr2:29446395-30142858&contains=1&rfilter=strand:-")
sb2 <- SnaptronQueryBuilder$new()
sb2<-sb2$from_url("http://snaptron.cs.jhu.edu/srav2/snaptron?regions=chr2:29416789-29446394&contains=1&rfilter=strand:-")
check_jir_output<-junction_inclusion_ratio(list(sb1),list(sb2))

#load(file="test_jir_output.rds")
test_jir_output<-readRDS(file="test_jir_output.rds")
all.equal(test_jir_output, check_jir_output)


######PSI testing
inclusion_group1 <- SnaptronQueryBuilder$new()
inclusion_group1 <- inclusion_group1$from_url("http://snaptron.cs.jhu.edu/srav2/snaptron?regions=chr1:94468008-94472172&exact=1&rfilter=strand:+")
inclusion_group2 <- SnaptronQueryBuilder$new()
inclusion_group2 <- inclusion_group2$from_url("http://snaptron.cs.jhu.edu/srav2/snaptron?regions=chr1:94472243-94475142&exact=1&rfilter=strand:+")
exclusion_group <- SnaptronQueryBuilder$new()
exclusion_group <- exclusion_group$from_url("http://snaptron.cs.jhu.edu/srav2/snaptron?regions=chr1:94468008-94475142&exact=1&rfilter=strand:+")

check_psi_output<-percent_spliced_in(list(inclusion_group1), list(inclusion_group2), list(exclusion_group), min_count=1)

test_psi_output<-readRDS(file="test_psi_output.rds")
all.equal(test_psi_output, check_psi_output)


######TS testing
inclusion_group1 <- SnaptronQueryBuilder$new()
inclusion_group1<-inclusion_group1$from_url("http://snaptron.cs.jhu.edu/gtex/snaptron?regions=chr4:20763023-20763023&either=2&rfilter=strand:-")
inclusion_group2 <- SnaptronQueryBuilder$new()
inclusion_group2<-inclusion_group2$from_url("http://snaptron.cs.jhu.edu/gtex/snaptron?regions=chr4:20763098-20763098&either=1&rfilter=strand:-")

check_ts_output<-tissue_specificity(list(inclusion_group1, inclusion_group2))
test_ts_output<-readRDS(file="test_ts_output.rds")
all.equal(test_ts_output, check_ts_output)

