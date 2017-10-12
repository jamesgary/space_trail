#!/bin/bash
aws s3 cp public s3://space-trail/ --recursive --grants=read=uri=http://acs.amazonaws.com/groups/global/AllUsers
echo "Deployed to http://space-trail.s3-website-us-west-2.amazonaws.com/!"
