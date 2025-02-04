% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/VFDB.R
\name{VFDB_pipeline}
\alias{VFDB_pipeline}
\title{VFDB.R
Generic Virulence Factor Profiler : SampleNo_contigs.fasta vs. VFDB database}
\usage{
VFDB_pipeline(Org_id, SampleNo, curr_work_dir)
}
\arguments{
\item{Org_id}{Organism to query: GAS, PNEUMO or GONO}

\item{SampleNo}{Sample number (or list of sample numbers) associated with contig.fasta file}

\item{curr_work_dir}{Start up directory from pipeline project to locate system file structure}
}
\value{
A table frame containing the results of the query
}
\description{
Takes Organism, Sample Number and queries a contig.fasta file
}
\details{
searches for virulence factors in genomic data
}
