#include <memory>
#include <iostream>

struct Node {
    Node(std::string data) : m_data(data) {
    }
    Node(const Node& node) : m_data(node.m_data) {
    }
    const std::string& data() const {
        return m_data;
    }
    void insert(const std::string& s) {
        if (m_data.compare(s) >= 0) {
            if (left) {
                left->insert(s);
            } else {
                left = std::make_unique<Node>(s);
            }
        } else {
            if (right) {
                right->insert(s);
            } else {
                right = std::make_unique<Node>(s);
            }
        }
    }
    void visit(std::function<void(Node&)> func) {
        if (left) {
            left->visit(func);
        }
        func(*this);
        if (right) {
            right->visit(func);
        }
    }

    std::unique_ptr<Node> left;
    std::unique_ptr<Node> right;
    std::string m_data;
};

struct Tree {
    std::unique_ptr<Node> root;
    void insert(const std::string& s) {
        if (root) {
            root->insert(s);
        } else {
            root = std::make_unique<Node>(s);
        }
    }
    void visit(std::function<void(Node&)> func) {
        if (root) {
            root->visit(func);
        }
    }

};


int main() {
    Tree t;
    t.insert("2");
    t.insert("-1");
    t.insert("44");
    t.insert("2");
    t.insert("hello");
    t.insert("10");
    t.insert("0");
    t.visit([](Node& n) { n.m_data += "1"; });
    t.visit([](const Node& n) { std::cout << n.data() << std::endl; });
}

