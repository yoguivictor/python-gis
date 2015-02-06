LOCAL_IMAGE     = python-gis
RELEASE_PATH	= yoguivictor

RELEASE_TAG	= latest
RELEASE_IMAGE   = $(RELEASE_PATH)/$(LOCAL_IMAGE):$(RELEASE_TAG)
RELEASE_UNSTABLE = $(RELEASE_PATH)/$(LOCAL_IMAGE):unstable
RELEASE_TESTING = $(RELEASE_PATH)/$(LOCAL_IMAGE):testing
RELEASE_STABLE = $(RELEASE_PATH)/$(LOCAL_IMAGE):stable

all             : build
 
.build          : .
	time sudo docker build --rm -t $(LOCAL_IMAGE) .
	sudo docker inspect -f '{{.Id}}' $(LOCAL_IMAGE) > .build

build           : .build
 
.release        : .build
	sudo docker tag -f $(LOCAL_IMAGE) $(RELEASE_IMAGE)
	sudo docker tag -f $(LOCAL_IMAGE) $(RELEASE_UNSTABLE)
	sudo docker push $(RELEASE_IMAGE)
	sudo docker push $(RELEASE_UNSTABLE)
	echo $(LOCAL_IMAGE):$(RELEASE_TAG) > .release

release		: .release
 
clean           :
	$(RM) .build .release

testing		:
	sudo docker tag -f $(LOCAL_IMAGE) $(RELEASE_TESTING)
	sudo docker push $(RELEASE_TESTING)

stable		:
	sudo docker tag -f $(LOCAL_IMAGE) $(RELEASE_STABLE)
	sudo docker push $(RELEASE_STABLE)
	

.PHONY          : push build all clean


