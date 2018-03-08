from jnpr.junos import Device
from jnpr.junos.utils.config import Config
from lxml import etree
import string
import argparse

arguments = {'hashtag': 'Configuration element hash tag'}

def build_xml_filter( root, element):
    path = []
    s = ''
    
    while element!= root:
        name = element.find( 'name')
        if name!=None:
            s = '<name>'+name.text+'</name>'+s            
        s = '<'+element.tag + '>'+s+'</'+element.tag+'>'
        element = element.getparent()
    return s
    
def main():

    parser = argparse.ArgumentParser(description='Displays configuration elements with select hashtag. Hashtags are configured at any level using "set apply-macro ht <hashtag-name>" command.')
    
    for key in arguments:
        parser.add_argument(('-' + key), required=True, help=arguments[key])
    args = parser.parse_args()

    dev = Device()
    dev.open()
    dev.timeout = 300
    xml_config = dev.rpc.get_config(options={'database':'committed','inherit':'inherit'})    
    paths = []
    #select all elements matching pattern
    for ht_element in xml_config.findall( './/apply-macro/data/[name=\'{}\']/../'.format( args.hashtag)):
        #filter by node id just in case        
        if ht_element.text == 'ht':
            s = build_xml_filter( xml_config, ht_element.getparent().getparent())
            paths.append( s)
    if paths:
        path = '<configuration>'+"".join( paths)+'</configuration>'    
        xml_config = dev.rpc.get_config( filter_xml=path,options={'database':'committed','inherit':'inherit', 'format':'text'})
        print xml_config.text
    else:
        print 'hashtag \'{}\' is not found'.format( args.hashtag)
    dev.close()

    
if __name__ == "__main__":
    main()
