FROM falcosecurity/falco-driver-loader:0.28.0

RUN apt-get update && apt --fix-broken install -y && apt-get install -y unzip
