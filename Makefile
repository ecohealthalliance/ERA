run:
	FLIRT_MONGO_URL=mongodb://flirt-reporting.eha.io/grits-net-meteor \
BIRT_MONGO_URL=mongodb://birt.eha.io/birt \
meteor run --settings settings.json -p 3540
