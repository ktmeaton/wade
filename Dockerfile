
# docker build -t phac-nml/wade:latest .
# docker run --rm -p 8787:8787 -e PASSWORD=password -v $(pwd)/local:/wade/local phac-nml/wade:latest

# The rocker base images provide R, RStudio, Shiny, and various tidyverse packages
# https://rocker-project.org/images/
FROM rocker/verse:4.3.2

# -----------------------------------------------------------------------------
# Dependencies

# Install the Shiny server
RUN /rocker_scripts/install_shiny_server.sh 1.5.21.1012

# R packages
RUN Rscript -e 'devtools::install_version("plyr", version = "1.8.9", repos = c("http://cran.us.r-project.org"))'
RUN Rscript -e 'devtools::install_version("here", version = "1.0.1", repos = c("http://cran.us.r-project.org"))'
RUN Rscript -e 'devtools::install_version("DT",   version = "0.31",  repos = c("http://cran.us.r-project.org"))'
Run Rscript -e 'BiocManager::install("ggtree")'
Run Rscript -e 'BiocManager::install("Biostrings")'

# BLAST
RUN wget https://ftp.ncbi.nlm.nih.gov/blast/executables/blast+/LATEST/ncbi-blast-2.15.0+-x64-linux.tar.gz \
  && tar -xvf ncbi-blast-2.15.0+-x64-linux.tar.gz \
  && mv ncbi-blast-2.15.0+/bin/* /usr/local/bin

# -----------------------------------------------------------------------------
# WADE 

# Download the repository, version control to specific commit
RUN git clone https://github.com/phac-nml/wade.git /wade \
  && cd /wade \
  && git checkout 67ceed16 \
  && git submodule update --init --recursive

# Remove hard-coded references to Windows C drive
# Replace all windows paths with unix paths
# Replace windows-specific 'shell' function with unix 'system'
RUN sed -i 's|C:\\\\WADE\\\\|/wade/local/|g' /wade/WADE.R \
  && grep -l '\\' /wade/*.R /wade/**/*.R  | xargs sed -i 's/\\\\/\//g' \
  && grep -i -l 'shell' /wade/*.R /wade/**/*.R | xargs sed -i 's/shell/system/g'

RUN Rscript -e 'install.packages("/wade", repos = NULL, type="source")'

# -----------------------------------------------------------------------------
# Rstudio

# give the 'rstudio' user access to the /wade directory
RUN chown -R rstudio:rstudio /wade
# set the working directory in rstudio to be /wade
RUN echo "setwd(\"/wade\")" > /home/rstudio/.Rprofile
