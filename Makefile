run:
	FLIRT_MONGO_URL=mongodb://flirt-reporting.eha.io/grits-net-meteor \
BIRT_MONGO_URL=mongodb://birt.eha.io/birt \
SPA_MONGO_URL=mongodb://spa.eha.io/promed \
meteor run --settings settings.json -p 3540
